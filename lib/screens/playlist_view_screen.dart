import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:just_audio/just_audio.dart';
import 'package:proto_music_player/screens/app_router_screen.dart';
import 'package:proto_music_player/services/helper_functions.dart';
import '../components/song_tile.dart';

class CommonViewScreen extends StatefulWidget {
  const CommonViewScreen({Key? key, required this.id, required this.type}) : super(key: key);
  final String id;
  final String type;
  @override
  State<CommonViewScreen> createState() => _CommonViewScreenState();
}

class _CommonViewScreenState extends State<CommonViewScreen> {
  Map data = {};
  List<SongResultTile> allSongResultsList = [];
  bool isLoaded = false;
  HtmlUnescape htmlDecode = HtmlUnescape();
  late bool isAddedToQueue;
  bool isLoading = false;
  bool play = false;
  int firstSongIndexInQueue = 0;
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
    //if in queue returns index != -1
    firstSongIndexInQueue = await HelperFunctions.getQueueIndexBySongId(data["data"]["songs"][0]["id"]);
    //put data into list
    if(data["status"] == "SUCCESS" && data["data"]["songs"].length != 0){
      int i = 0;
      for(Map song in data["data"]["songs"]){
        isAddedToQueue = HelperFunctions.checkIfAddedInQueue(data["data"]["songs"][i]["id"]);
        allSongResultsList.add(SongResultTile(player: mainAudioPlayer,song: song,));
        i++;
      }
    }
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> addSongsToQueue()async{
    if(!isAddedToQueue){
      if(mounted){
        setState(() {
          isLoading = true;
        });
        Future.delayed(const Duration(milliseconds: 1500),(){setState(() {
          isLoading = false;
        });});
        setState(() {
          firstSongIndexInQueue = 0;
          isAddedToQueue = true;
        });
        await HelperFunctions.playGivenListOfSongs(data["data"]["songs"]);
      }
    }
  }
  bool doesBelong(){
   try{
     //checks whether current playing song belongs to album;
     if (kDebugMode) {
       print("current index : ${mainAudioPlayer.currentIndex!} , first song index : $firstSongIndexInQueue , queue len :${AppRouter.queue.length}");
     }
     if(firstSongIndexInQueue != -1 && mainAudioPlayer.currentIndex! >= firstSongIndexInQueue &&
         data["data"]["songs"][mainAudioPlayer.currentIndex! - firstSongIndexInQueue ]["id"] == mainAudioPlayer.sequence![mainAudioPlayer.currentIndex!].tag.extras["id"]){
       //does belong
       return true;
     }
     //does not belong
     return false;
   }catch(e){
     if (kDebugMode) {
       print("checker error : $e");
     }
     //error
     return false;
   }
  }
  Widget playPauseButton(AudioPlayer player, PlayerState playerState ,double iconSize) {
    final processingState = playerState.processingState;
    //albums first song index
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering || isLoading) {
      return SpinKitRipple(
        color: Colors.white,
        size: iconSize + 16.5,
      );
    } else if (!player.playing|| (processingState != ProcessingState.completed)) {
      //play button
      if(!player.playing || !doesBelong()) {
        return GestureDetector(
        onTap:()async{
          if(!isAddedToQueue){
            await addSongsToQueue();
          }
          else {
            //check whether the current playing song belongs to the album.if not seek to first songs index.
            if(!doesBelong()){
              //seek to albums first song in the queue
                mainAudioPlayer.seek(Duration.zero,index: firstSongIndexInQueue);
            }
            //play
            await mainAudioPlayer.play();
          }
        },
        child: Icon(
          Icons.play_circle,color:Colors.blue,
          size: iconSize,
        ),
      );
      }
      //pause button is returned when player is playing
      return GestureDetector(
        onTap:()async{
          await mainAudioPlayer.pause();
        },
        child: Icon(
          Icons.pause_circle,color:  Colors.blue,
          size: iconSize,
        ),
      );
    } else {
      return GestureDetector(
        onTap:() =>player.seek(Duration.zero,
            index: firstSongIndexInQueue
        ),
        child: Icon(
          Icons.replay,color:Colors.blue,
          size: iconSize,
        ),
      );
    }
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
                                      StreamBuilder(
                                        stream: mainAudioPlayer.playerStateStream,
                                        builder: (_,AsyncSnapshot<PlayerState> snapshot){
                                          if(snapshot.hasData){
                                            return playPauseButton(mainAudioPlayer, snapshot.data!, 60);
                                          }else{
                                            return const SizedBox(height: 0,width: 0,);
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            //All rendered songs
                            HelperFunctions.listViewRenderer(allSongResultsList, verticalGap: 5),
                            const SizedBox(height: 70,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
                :ListView(
                  children: const [
                    Center(
              heightFactor: 15,
              child: CircularProgressIndicator(color: Colors.white,),
            ),
                  ],
                ),
            HelperFunctions.collapsedPlayer()
          ],
        )
      ),
    );
  }

}