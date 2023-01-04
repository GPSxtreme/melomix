import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:proto_music_player/screens/app_router_screen.dart';
import 'package:proto_music_player/services/helper_functions.dart';
import '../components/song_tile.dart';

class PlaylistViewScreen extends StatefulWidget {
  const PlaylistViewScreen({Key? key, required this.id, required this.type}) : super(key: key);
  final String id;
  final String type;
  @override
  State<PlaylistViewScreen> createState() => _PlaylistViewScreenState();
}

class _PlaylistViewScreenState extends State<PlaylistViewScreen> {
  Map data = {};
  List<SongResultTile> allSongResultsList = [];
  bool isLoaded = false;
  HtmlUnescape htmlDecode = HtmlUnescape();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //fetch album/playlist details
    fetchData();
  }
  fetchData()async{
    if(widget.type == "album"){
      data = await HelperFunctions.getAlbumById(widget.id);
    }else{
      data = await HelperFunctions.getPlaylistById(widget.id);
    }
    putDataToList();
  }
  putDataToList(){
    if(data["status"] == "SUCCESS" && data["data"]["songs"].length != 0){
      for(Map song in data["data"]["songs"]){
        allSongResultsList.add(SongResultTile(player: mainAudioPlayer,song: song,));
      }
    }
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            isLoaded?
            ListView(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          image: NetworkImage(data["data"]["image"][2]["link"]),
                          fit: BoxFit.cover,
                          opacity: 1
                      )
                  ),
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter:ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                                  Colors.black12.withOpacity(0.0),
                                  Colors.black.withOpacity(0.85),
                                  Colors.black.withOpacity(0.98),
                                  Colors.black.withOpacity(1),
                                ],
                                stops: const [
                                  0.0,
                                  0.18,
                                  0.25,
                                  1.0
                                ])
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20,),
                            Center(child: Image.network(data["data"]["image"][2]["link"],height: 180,width: 180,)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    htmlDecode.convert(data["data"]["name"]).trim(),
                                    maxLines: 2,
                                    style: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w800),
                                    textAlign: TextAlign.center,
                                    overflow:TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 15,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.type == "album" ? htmlDecode.convert(data["data"]["primaryArtists"]).trim():htmlDecode.convert(data["data"]["userId"]).trim(),
                                            maxLines: 2,
                                            style: const TextStyle(color: Colors.white60,fontSize: 18,fontWeight: FontWeight.w700),
                                            textAlign: TextAlign.center,
                                            overflow:TextOverflow.ellipsis,
                                          ),
                                            const SizedBox(height: 15,),
                                            Text(
                                              "${widget.type.toUpperCase()} ${widget.type == "album" ? htmlDecode.convert(data["data"]["releaseDate"]).toString().split("-")[0]:null}",
                                              maxLines: 1,
                                              style: const TextStyle(color: Colors.white60,fontSize: 13,fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                              overflow:TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                      const Spacer(),
                                      IconButton(onPressed: ()async{
                                        await HelperFunctions.playGivenListOfSongs(data["data"]["songs"]);
                                      }, icon: const Icon(Icons.play_circle,color: Colors.blue,size: 60,))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            //All rendered songs
                            HelperFunctions.listViewRenderer(allSongResultsList, verticalGap: 5),
                            if(mainAudioPlayer.playing)
                              const SizedBox(height: 70,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ):const Center(
              heightFactor: 15,
              child: CircularProgressIndicator(color: Colors.white,),
            ),
            HelperFunctions.collapsedPlayer()
          ],
        )
      ),
    );
  }
}
