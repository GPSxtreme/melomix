import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';
import 'package:proto_music_player/components/album_tile.dart';
import 'package:proto_music_player/components/artist_tile.dart';
import 'package:proto_music_player/components/playlist_tile.dart';
import '../components/song_tile.dart';
import '../services/helper_functions.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.player}) : super(key: key);
  final AudioPlayer player;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map allSongResultsData = {};
  List<SongResultTile> allSongResultsList = [];
  Map allDataResultsData = {};
  List<SongResultTile> topSongsResultsList = [];
  List<PlaylistTile> playlistsResultsList = [];
  List<AlbumTile> albumsResultsList = [];
  List<ArtistTile> artistsResultsList = [];
  bool userSearched = false;
  dynamic topResult;


  resetData(){
    setState(() {
      topResult = null;
      topSongsResultsList.clear();
      playlistsResultsList.clear();
      albumsResultsList.clear();
      artistsResultsList.clear();
    });
  }

  getAllSongResults(String query)async{
    // if(allResults.length > 10){
      setState(() {
        allSongResultsList.clear();
      });
    // }
    allSongResultsData = await HelperFunctions.getSongByName(query.trim(), 10);
    if(allSongResultsData["status"] == "SUCCESS" && allSongResultsData["data"]["results"].isNotEmpty){
      for(Map song in allSongResultsData["data"]["results"]){
        setState(() {
          allSongResultsList.add(SongResultTile(song: song,player: widget.player,));
        });
      }
    }
  }

  assignTopResult(Map data)async{
    topResult = null;
    switch(data["type"]){
      case "artist" :
        topResult = ArtistTile(artUrl: data["image"][2]["link"], artistId: data["id"]);
        break;
      case "album" :
        topResult = AlbumTile(artUrl: data["image"][2]["link"], albumId: data["id"]);
        break;
      case "song" :
        Map fetchedSong = await HelperFunctions.getSongById(data["id"]);
        topResult = SongResultTile(player: widget.player, song: fetchedSong["data"][0]);
        break;
      case "playlist" :
        topResult = PlaylistTile(artUrl: data["image"][2]["link"], playlistId: data["id"]);
    }
  }

  getAllDataResults(String query)async{
    resetData();
    allDataResultsData = await HelperFunctions.searchAll(query.trim());
    if(allDataResultsData["status"] == "SUCCESS" && allDataResultsData["data"] != null){
      if(allDataResultsData["data"]["topQuery"]["results"].isNotEmpty){
        for(Map topQuery in allDataResultsData["data"]["topQuery"]["results"]){
          assignTopResult(topQuery);
        }
      }
      if(allDataResultsData["data"]["songs"]["results"].isNotEmpty){
        for(Map song in allDataResultsData["data"]["songs"]["results"]){
          Map fetchedSong = await HelperFunctions.getSongById(song["id"]);
          topSongsResultsList.add(SongResultTile(player: widget.player, song: fetchedSong["data"][0] ));
        }
      }
      if(allDataResultsData["data"]["albums"]["results"].isNotEmpty){
        for(Map album in allDataResultsData["data"]["albums"]["results"]){
          albumsResultsList.add(AlbumTile(albumId: album["id"],artUrl: album["image"][2]["link"],));
        }
      }
      if(allDataResultsData["data"]["artists"]["results"].isNotEmpty){
        for(Map artist in allDataResultsData["data"]["artists"]["results"]){
          artistsResultsList.add(ArtistTile(artistId: artist["id"],artUrl: artist["image"][2]["link"],));
        }
      }
      if(allDataResultsData["data"]["playlists"]["results"].isNotEmpty){
        for(Map playlist in allDataResultsData["data"]["playlists"]["results"]){
          playlistsResultsList.add(PlaylistTile(playlistId: playlist["id"],artUrl: playlist["image"][2]["link"],));
        }
      }
    }
  }
  
  Widget listViewRenderer(List<SongResultTile> list){
    if(list.isNotEmpty){
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: list[index],
          );
        },
      );
    }else{
      return const Text("no results",style: TextStyle(color: Colors.white),);
    }
  }

  Widget gridViewRenderer(List list){
    if(list.isNotEmpty){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: list[index],
            );
          }, gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisSpacing: 10,crossAxisSpacing: 10),
        ),
      );
    }else{
      return const Text("no results",style: TextStyle(color: Colors.white),);
    }
  }

  Widget label(String name) =>  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 18),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:  [
            Text(name,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white),textAlign: TextAlign.start,),
          ],
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          Column(
          children: [
            //Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              child: TextField(
                textAlign: TextAlign.start,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                cursorHeight: 20,
                keyboardType: TextInputType.name,
                onSubmitted: (query)async{
                  if(query.trim().isNotEmpty){
                    setState(() {
                      userSearched = true;
                    });
                    FocusManager.instance.primaryFocus?.unfocus();
                    await getAllDataResults(query);
                    await getAllSongResults(query);
                  }
                },
                onChanged:(query){
                  if(query.trim().isEmpty){
                    setState(() {
                      userSearched = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(icon: const Icon(Icons.sort,color: Colors.white,), onPressed: () {},),
                  filled: true,
                  fillColor: HexColor("111111"),
                  hintText: 'What do you want to listen to?',
                  hintStyle: const TextStyle(color: Colors.white24),
                  prefixIcon: const Icon(Icons.search,color: Colors.white,),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("111111"), width: 3),
                      borderRadius: BorderRadius.circular(100)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("111111"), width: 3),
                      borderRadius: BorderRadius.circular(100)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("111111"), width: 3),
                      borderRadius: BorderRadius.circular(100)
                  ),
                ),
              ),
            ),
            if(allSongResultsList.isEmpty && userSearched)
              const Center(
                  heightFactor: 15,
                  child: CircularProgressIndicator(color: Colors.white,)
              ),
            if(userSearched) ...[
              if(topResult != null) ...[
                label("Top result"),
                if(topResult.runtimeType == SongResultTile)
                topResult,
                if(topResult.runtimeType != SongResultTile)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,children: [
                    topResult
                  ],),
                ),
              ],
              if(topSongsResultsList.isNotEmpty) ...[
                label("Top songs"),
                listViewRenderer(topSongsResultsList),
              ],
              if(albumsResultsList.isNotEmpty) ...[
                label("Albums"),
                gridViewRenderer(albumsResultsList),
              ],
              if(artistsResultsList.isNotEmpty) ...[
                label("Artists"),
                gridViewRenderer(artistsResultsList),
              ],
              if(playlistsResultsList.isNotEmpty) ...[
                label("Playlists"),
                gridViewRenderer(playlistsResultsList),
              ],
              if(allSongResultsList.isNotEmpty) ...[
                label("All song results"),
                listViewRenderer(allSongResultsList),
              ],
              if(widget.player.playing)
                const SizedBox(height: 60,),
            ],
            if(!userSearched) ...[
              const Center(
                heightFactor: 20,
                child: Text("Search for a song to show results.",style: TextStyle(color: Colors.white,fontSize: 15),),
              )
            ]
          ],
        )],
      ),
    );
  }

}
