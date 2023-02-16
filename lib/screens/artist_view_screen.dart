import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:proto_music_player/screens/app_router_screen.dart';
import 'package:proto_music_player/services/helper_functions.dart';
import '../components/online_song_tile.dart';
import '../components/top_album_tile.dart';

class ArtistViewScreen extends StatefulWidget {
  const ArtistViewScreen({Key? key, required this.artistId}) : super(key: key);
  final String artistId;
  @override
  State<ArtistViewScreen> createState() => _ArtistViewScreenState();
}

class _ArtistViewScreenState extends State<ArtistViewScreen> {
  bool isLoaded = false;
  Map artistDetails = {};
  List<OnlineSongResultTile> songs = [];
  List<TopAlbumTile> albums = [];
  List<OnlineSongResultTile> recommendations = [];
  HtmlUnescape htmlDecode = HtmlUnescape();
  var formatter = NumberFormat('#,##,000');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
  fetchData()async{
    if(mounted){
      artistDetails = await HelperFunctions.getArtistDetails(widget.artistId);
      final artistSongs = await HelperFunctions.getArtistSongs(widget.artistId, "1");
      final artistAlbums = await HelperFunctions.getArtistAlbums(widget.artistId, "1");
      //put data into tiles.
      if(artistSongs["data"]["results"].isNotEmpty){
        for(Map song in artistSongs["data"]["results"]){
          songs.add(OnlineSongResultTile(player: mainAudioPlayer, song: song));
        }
        //fetch artist recommendations.
        final artistRecommendations = await HelperFunctions.getArtistRecommendations(widget.artistId, artistSongs["data"]["results"][0]["id"]);
        for(Map song in artistRecommendations["data"]){
          recommendations.add(OnlineSongResultTile(player: mainAudioPlayer, song: song));
        }
      }
      if(artistAlbums["data"]["results"].isNotEmpty){
        for(Map album in artistAlbums["data"]["results"]){
          albums.add(TopAlbumTile(data: album));
        }
      }
    }
    setState(() {
      isLoaded = true;
    });
  }
  Widget label(String name) =>  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:  [
            Text(name,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.white),textAlign: TextAlign.start,),
          ],
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    if(isLoaded){
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(artistDetails["data"]["image"][2]["link"]),
                      fit: BoxFit.cover,
                      opacity: 1
                    ),
                  ),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Colors.black12.withOpacity(0.0),
                                Colors.black.withOpacity(0.2),
                                Colors.black.withOpacity(0.5),
                                Colors.black.withOpacity(1),
                              ],
                              stops: const [
                                0.0,
                                0.3,
                                0.8,
                                1.0
                              ])
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 25,),
                            //artist picture
                            Center(
                                child: Material(
                                    elevation: 10,
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(65),
                                    child: CircleAvatar(
                                      radius: 90,
                                      backgroundImage: NetworkImage(artistDetails["data"]["image"][2]["link"],),
                                      backgroundColor: Colors.transparent,
                                    )
                                )
                            ),
                            //artist details
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    htmlDecode.convert(artistDetails["data"]["name"]).trim(),
                                    maxLines: 2,
                                    style: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w800),
                                    textAlign: TextAlign.center,
                                    overflow:TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 15,),
                                  Text(
                                    "${artistDetails["data"]["dominantType"].trim()} . ${artistDetails["data"]["dominantLanguage"].trim()}",
                                    maxLines: 2,
                                    style: const TextStyle(color: Colors.white70,fontSize: 18 ,fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center,
                                    overflow:TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 15,),
                                  Row(
                                    children: [
                                      const Icon(Icons.people_alt_rounded,color: Colors.white70,size: 25,),
                                      Text(
                                        " ${formatter.format(int.parse(artistDetails["data"]["fanCount"]))}",
                                        maxLines: 2,
                                        style: const TextStyle(color: Colors.white70,fontSize: 18 ,fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.center,
                                        overflow:TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if(recommendations.isNotEmpty) ...[
                  label("Artist pick's"),
                  HelperFunctions.listViewRenderer(recommendations.sublist(0,5), verticalGap: 2),
                ],
                if(songs.isNotEmpty) ...[
                  label("songs"),
                  HelperFunctions.listViewRenderer(songs, verticalGap: 2),
                ],
                if(albums.isNotEmpty) ...[
                  label("Albums"),
                  HelperFunctions.gridViewRenderer(albums,horizontalPadding: 20, verticalPadding: 8, crossAxisCount: 2, crossAxisSpacing: 15,mainAxisSpacing: 10),
                ],
                const SizedBox(height: 70,),
              ]
            ),
            //collapsed player
            HelperFunctions.collapsedPlayer()
          ],
        ),
      );
    }else{
      return const Center(
          heightFactor: 7,
          child: SpinKitRipple(color: Colors.white,size: 80,)
      );
    }
  }
}

