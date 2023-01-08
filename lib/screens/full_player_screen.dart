// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../components/player_buttons.dart';
import '../services/helper_functions.dart';
import 'app_router_screen.dart';
import 'lyrics_screen.dart';
import 'package:html_unescape/html_unescape.dart';

class ShowFullPlayer extends StatefulWidget {
  const ShowFullPlayer({Key? key,}) : super(key: key);
  @override
  State<ShowFullPlayer> createState() => _ShowFullPlayerState();
}

class _ShowFullPlayerState extends State<ShowFullPlayer> {
  HtmlUnescape htmlDecode = HtmlUnescape();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: mainAudioPlayer.currentIndexStream,
        builder:(context,AsyncSnapshot<int?> snapshot){
          if(snapshot.data != null){
            Map songData = mainAudioPlayer.audioSource!.sequence[snapshot.data!].tag.extras;
            String hasLyrics = songData["hasLyrics"];
            late dynamic localImage;
            Random random = Random();
            bool isLocal = songData["isLocal"] != null;
            ImageProvider artwork(){
              if(songData["isLocal"] != null && songData["isLocal"]) {
                return localImage;
              } else {
                return NetworkImage(
                    songData["image"][2]["link"]
                );
              }
            }
            Widget songCover(){
              bool isLocalWithArtwork = isLocal && songData["isLocal"] && localImage.runtimeType != bool;
              return Container(
                width: MediaQuery.of(context).orientation == Orientation.portrait ?  MediaQuery.of(context).size.width*0.65 : MediaQuery.of(context).size.height*0.75 ,
                height: MediaQuery.of(context).orientation == Orientation.portrait ?  MediaQuery.of(context).size.width*0.65 : MediaQuery.of(context).size.height*0.75 ,
                decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color:  isLocal && !isLocalWithArtwork ?  Colors.accents.elementAt(songData["intId"] % Colors.accents.length).withOpacity(0.8) : null,
                  image: ( isLocalWithArtwork ) || songData["isLocal"] == null ?
                  DecorationImage(
                      fit: BoxFit.fill,
                      image:artwork()
                  ) : null,
                ),
                child:(!isLocalWithArtwork && isLocal) ?
                const Center(
                  child: Icon(Icons.music_note_rounded,size: 120,color: Colors.white,)
                ):null,
              );
            }

            Widget songName(){
              return Text(htmlDecode.convert(songData["name"]),style: const TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,);
            }

            Widget songArtists(){
              return Text(htmlDecode.convert(songData["primaryArtists"]),style: const TextStyle(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.w500),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis);
            }

            Widget songLyricsBtn(){
              if(hasLyrics == "true") {
                return SizedBox(
                  width: 100,
                  child: Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue
                        ),
                        onPressed: ()async{
                          Map lyrics =  await HelperFunctions.fetchLyrics(songData["id"]);
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ShowLyrics(lyrics:lyrics,)
                          );
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.lyrics,color: Colors.white,),
                            SizedBox(width: 5,),
                            Text("Lyrics",style: TextStyle(color: Colors.white,)),
                          ],
                        )),
                  ),
                );
              } else {
                return const SizedBox(height: 0,);
              }
            }

            Widget songTimers(){
              return Row(
                children: [
                  StreamBuilder(
                    stream: mainAudioPlayer.createPositionStream(),
                    builder: (context,AsyncSnapshot<Duration?> snapshot){
                      if(snapshot.data != null){
                        return Text(HelperFunctions.printDuration(snapshot.data!), style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),textAlign: TextAlign.start,);
                      } else {
                        return const Text("");
                      }
                    },
                  ),
                  const Spacer(),
                  StreamBuilder(
                    stream: mainAudioPlayer.durationStream,
                    builder: (context,AsyncSnapshot<Duration?> snapshot){
                      if(snapshot.data != null){
                        return Text(HelperFunctions.printDuration(snapshot.data!), style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),textAlign: TextAlign.start,);
                      } else {
                        return const Text("");
                      }
                    },
                  ),
                ],
              );
            }

            Widget cprAndPlayer(){
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height*0.4 : MediaQuery.of(context).size.width*0.6,
                  maxHeight: MediaQuery.of(context).size.height*0.4,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if(hasLyrics == "true") ...[
                        songLyricsBtn(),
                        const SizedBox(height: 20,),
                      ],
                      Text(songData["copyright"] ?? "",style: const TextStyle(color: Colors.white70,fontSize: 12,fontWeight: FontWeight.w500),textAlign: TextAlign.center,maxLines: 3,overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8),
                        child: songTimers(),
                      ),
                      PlayerController(mainAudioPlayer, isFullScreen: true,nextBtnSize: 30,playPauseBtnSize: 50,prevBtnSize: 30,repeatBtnSize: 30,shuffleBtnSize: 30,)
                    ],
                  ),
                ),
              );
            }

            Widget page() {
              bool isLocalWithArtwork = isLocal && songData["isLocal"] && localImage.runtimeType != bool;
              return GestureDetector(
                onPanUpdate: (details){
                  int sensitivity = 17;
                  // print(details.delta.dx);
                  if(details.delta.dx > sensitivity){
                    if(mainAudioPlayer.hasPrevious){
                      mainAudioPlayer.seekToPrevious();
                    }
                  } else if (details.delta.dx < -sensitivity){
                    if(mainAudioPlayer.hasNext){
                      mainAudioPlayer.seekToNext();
                    }
                  }
                },
                child: DraggableScrollableSheet(
                  initialChildSize: 1,
                  minChildSize: 0.5,
                  maxChildSize: 1,
                  builder: (_,controller) {
                    return Container(
                      decoration: BoxDecoration(
                        color: HexColor("111111"),
                        image: isLocalWithArtwork || !isLocal ?
                        DecorationImage(
                            fit: BoxFit.fill,
                            opacity: 0.8,
                            image:artwork()
                        ) : null,
                      ),
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                            child: MediaQuery.of(context).orientation == Orientation.portrait ?
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                songCover(),
                                const SizedBox(height: 25,),
                                songName(),
                                const SizedBox(height: 5,),
                                songArtists(),
                                const Spacer(),
                                cprAndPlayer(),
                                const Spacer(),
                              ],
                            )
                                :
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                songCover(),
                                const Spacer(),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Spacer(),
                                      songName(),
                                      const SizedBox(height: 5,),
                                      songArtists(),
                                      const Spacer(),
                                      songLyricsBtn(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                                        child: songTimers(),
                                      ),
                                      PlayerController(mainAudioPlayer, isFullScreen: true,nextBtnSize: 30,playPauseBtnSize: 50,prevBtnSize: 30,repeatBtnSize: 30,shuffleBtnSize: 30,),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } ,
                ),
              );
            };

            if(songData["isLocal"] != null && songData["isLocal"] ){
              return FutureBuilder(
                future: HelperFunctions.getLocalSongArtworkImage(songData["intId"]),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.hasData){
                    localImage = snapshot.data!;
                    return page();
                  } else{
                    return const SizedBox(height: 0,width: 0,);
                  }
                },
              );
            }else{
              return page();
            }
          }else{
            return const SizedBox(height: 0,);
          }
        }
    );
  }
}
