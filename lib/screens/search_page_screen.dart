import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:proto_music_player/components/results_common_tile.dart';
import 'package:proto_music_player/components/top_result_common_tile.dart';
import 'package:proto_music_player/screens/app_router_screen.dart';
import '../components/song_tile.dart';
import '../services/helper_functions.dart';

class SearchPageScreen extends StatefulWidget {
  const SearchPageScreen({Key? key,}) : super(key: key);
  static String id = "search_screen";
  @override
  State<SearchPageScreen> createState() => _SearchPageScreenState();
}

class _SearchPageScreenState extends State<SearchPageScreen> {
  Map allSongResultsData = {};
  List<SongResultTile> allSongResultsList = [];
  Map allDataResultsData = {};
  List<SongResultTile> topSongsResultsList = [];
  List<CommonResultTile> playlistsResultsList = [];
  List<CommonResultTile> albumsResultsList = [];
  List<CommonResultTile> artistsResultsList = [];
  bool userSearched = false;
  bool noResults = false;
  dynamic topResult;
  String lastSavedQuery = "";

  resetData(){
    setState(() {
      topResult = null;
      topSongsResultsList.clear();
      playlistsResultsList.clear();
      albumsResultsList.clear();
      artistsResultsList.clear();
      allSongResultsList.clear();
    });
  }

  getAllSongResults(String query)async{
    allSongResultsData = await HelperFunctions.getSongByName(query.trim(), 10);
    if(allSongResultsData["status"] == "SUCCESS" && allSongResultsData["data"]["results"].isNotEmpty){
      for(Map song in allSongResultsData["data"]["results"]){
        setState(() {
          allSongResultsList.add(SongResultTile(song: song,player: mainAudioPlayer,));
        });
      }
    }
  }

  assignTopResult(Map data)async{
    topResult = null;
    if(data["type"] == "song"){
      Map fetchedSong = await HelperFunctions.getSongById(data["id"]);
      topResult = SongResultTile(player: mainAudioPlayer, song: fetchedSong["data"][0]);
    }else {
      topResult = TopCommonResultTile(data: data);
    }

  }

  getAllDataResults(String query)async{
    resetData();
    allDataResultsData = await HelperFunctions.searchAll(query.trim());
    if(allDataResultsData["data"]["songs"]["results"].isEmpty){
      setState(() {
        noResults = true;
      });
      return;
    }
    else if(allDataResultsData["status"] == "SUCCESS" && allDataResultsData["data"] != null){
      if(allDataResultsData["data"]["topQuery"]["results"].isNotEmpty){
        for(Map topQuery in allDataResultsData["data"]["topQuery"]["results"]){
          assignTopResult(topQuery);
        }
      }
      if(allDataResultsData["data"]["songs"]["results"].isNotEmpty){
        for(Map song in allDataResultsData["data"]["songs"]["results"]){
          Map fetchedSong = await HelperFunctions.getSongById(song["id"]);
          topSongsResultsList.add(SongResultTile(player: mainAudioPlayer, song: fetchedSong["data"][0] ));
        }
      }
      if(allDataResultsData["data"]["albums"]["results"].isNotEmpty){
        for(Map album in allDataResultsData["data"]["albums"]["results"]){
          albumsResultsList.add(CommonResultTile(data: album,));
        }
      }
      if(allDataResultsData["data"]["artists"]["results"].isNotEmpty){
        for(Map artist in allDataResultsData["data"]["artists"]["results"]){
          artistsResultsList.add(CommonResultTile(data: artist,));
        }
      }
      if(allDataResultsData["data"]["playlists"]["results"].isNotEmpty){
        for(Map playlist in allDataResultsData["data"]["playlists"]["results"]){
          playlistsResultsList.add(CommonResultTile(data: playlist,));
        }
      }
    }
    getAllSongResults(query);
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
      child: Scaffold(
        appBar: null,
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ListView(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10,),
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
                          if(query.trim().isNotEmpty && query != lastSavedQuery){
                            setState(() {
                              userSearched = true;
                              noResults = false;
                              lastSavedQuery = query;
                            });
                            await getAllDataResults(query);
                          }
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        onChanged:(query){
                          if(query.trim().isEmpty){
                            setState(() {
                              lastSavedQuery = "";
                              userSearched = false;
                              noResults = false;
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
                    if(allSongResultsList.isEmpty && userSearched && !noResults)
                      const Center(
                          heightFactor: 15,
                          child: CircularProgressIndicator(color: Colors.white,)
                      ),
                    if(userSearched) ...[
                      if(topResult != null) ...[
                        label("Top result"),
                        topResult
                      ],
                      if(topSongsResultsList.isNotEmpty) ...[
                        label("Top songs"),
                        HelperFunctions.listViewRenderer(topSongsResultsList,verticalGap: 5),
                      ],
                      if(albumsResultsList.isNotEmpty) ...[
                        label("Albums"),
                        HelperFunctions.gridViewRenderer(albumsResultsList, horizontalPadding: 13, verticalPadding: 5, crossAxisCount: 3, crossAxisSpacing: 10),
                      ],
                      if(artistsResultsList.isNotEmpty) ...[
                        label("Artists"),
                        HelperFunctions.gridViewRenderer(artistsResultsList, horizontalPadding: 13, verticalPadding: 5, crossAxisCount: 3, crossAxisSpacing: 10),
                      ],
                      if(playlistsResultsList.isNotEmpty) ...[
                        label("Playlists"),
                        HelperFunctions.gridViewRenderer(playlistsResultsList, horizontalPadding: 13, verticalPadding: 5, crossAxisCount: 3, crossAxisSpacing: 10),
                      ],
                      if(allSongResultsList.isNotEmpty) ...[
                        label("All song results"),
                        HelperFunctions.listViewRenderer(allSongResultsList, verticalGap: 5),
                      ],
                      if(mainAudioPlayer.playing)
                        const SizedBox(height: 60,),
                    ],
                    if(!userSearched) ...[
                      const Center(
                        heightFactor: 20,
                        child: Text("Search for a song to show results.",style: TextStyle(color: Colors.white,fontSize: 15),),
                      ),
                    ],
                    if(noResults)
                      const Center(
                        heightFactor: 20,
                        child: Text("No results found!",style: TextStyle(color: Colors.white,fontSize: 16)),
                      )
                  ],
                )],
            ),
            HelperFunctions.collapsedPlayer()
          ] ,
        ),
      ),
    );
  }

}
