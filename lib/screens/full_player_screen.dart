// ignore_for_file: use_build_context_synchronously

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
            String hasLyrics = mainAudioPlayer.audioSource!.sequence[snapshot.data!].tag.extras["hasLyrics"];
            Widget songCover(){
              return Container(
                width: MediaQuery.of(context).orientation == Orientation.portrait ?  MediaQuery.of(context).size.width*0.70 : MediaQuery.of(context).size.height*0.75 ,
                height: MediaQuery.of(context).orientation == Orientation.portrait ?  MediaQuery.of(context).size.width*0.70 : MediaQuery.of(context).size.height*0.75 ,
                decoration:BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        mainAudioPlayer.audioSource!.sequence[snapshot.data!].tag.extras["image"][2]["link"]
                      ),
                      fit: BoxFit.cover
                  ),
                ),
              );
            }
            Widget songName(){
              return Text(htmlDecode.convert(mainAudioPlayer.audioSource!.sequence[snapshot.data!].tag.extras["name"]),style: const TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,);
            }
            Widget songArtists(){
              return Text(htmlDecode.convert(mainAudioPlayer.audioSource!.sequence[snapshot.data!].tag.extras["primaryArtists"]),style: const TextStyle(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.w500),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis);
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
                          Map lyrics =  await HelperFunctions.fetchLyrics(mainAudioPlayer.audioSource!.sequence[snapshot.data!].tag.extras["id"]);
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
                  if(mainAudioPlayer.duration != null)
                    Text(HelperFunctions.printDuration(mainAudioPlayer.duration!), style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),textAlign: TextAlign.start,)
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
                      Text(mainAudioPlayer.audioSource!.sequence[snapshot.data!].tag.extras["copyright"] ?? "",style: const TextStyle(color: Colors.white70,fontSize: 12,fontWeight: FontWeight.w500),textAlign: TextAlign.center,maxLines: 3,overflow: TextOverflow.ellipsis),
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
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            opacity: 0.8,
                            image: NetworkImage(
                              mainAudioPlayer.audioSource!.sequence[snapshot.data!].tag.extras["image"][2]["link"],
                            )
                        )
                    ),
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                          child: MediaQuery.of(context).orientation == Orientation.portrait ?  Column(
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
                          ) : Row(
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
          }else{
            return const SizedBox(height: 0,);
          }
        }
    );
  }
}
