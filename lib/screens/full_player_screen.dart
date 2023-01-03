import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';
import '../components/playerButtons.dart';
import '../services/helperFunctions.dart';
import 'home_screen.dart';
import 'lyrics_screen.dart';

class ShowFullPlayer extends StatefulWidget {
  const ShowFullPlayer({Key? key, required this.player}) : super(key: key);
  final AudioPlayer player;
  @override
  State<ShowFullPlayer> createState() => _ShowFullPlayerState();
}

class _ShowFullPlayerState extends State<ShowFullPlayer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.player.currentIndexStream,
        builder:(context,snapshot){
          if(snapshot.data != null){
            String hasLyrics = HomeScreen.audioQueueSongData[snapshot.data!]["hasLyrics"];
            Widget songCover(){
              return Container(
                width: MediaQuery.of(context).orientation == Orientation.portrait ?  MediaQuery.of(context).size.width*0.75 : MediaQuery.of(context).size.height*0.75 ,
                height: MediaQuery.of(context).orientation == Orientation.portrait ?  MediaQuery.of(context).size.width*0.75 : MediaQuery.of(context).size.height*0.75 ,
                decoration:BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        HomeScreen.audioQueueSongData[snapshot.data!]["image"][2]["link"],
                      ),
                      fit: BoxFit.cover
                  ),
                ),
              );
            }
            Widget songName(){
              return Text(HomeScreen.audioQueueSongData[snapshot.data!]["name"],style: const TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,);
            }
            Widget songArtists(){
              return Text(HomeScreen.audioQueueSongData[snapshot.data!]["primaryArtists"] ?? "",style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w400),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis);
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
                        onPressed: (){
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ShowLyrics(index: snapshot.data!,)
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
                    stream: widget.player.createPositionStream(),
                    builder: (context,snapshot){
                      if(snapshot.data != null){
                        return Text(HelperFunctions.printDuration(snapshot.data!), style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),textAlign: TextAlign.start,);
                      } else {
                        return const Text("");
                      }
                    },
                  ),
                  const Spacer(),
                  if(widget.player.duration != null)
                    Text(HelperFunctions.printDuration(widget.player.duration!), style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),textAlign: TextAlign.start,)
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
                      Text(HomeScreen.audioQueueSongData[snapshot.data!]["copyright"] ?? "",style: const TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w300),textAlign: TextAlign.center,maxLines: 3,overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8),
                        child: songTimers(),
                      ),
                      PlayerController(widget.player, isFullScreen: true,nextBtnSize: 30,playPauseBtnSize: 50,prevBtnSize: 30,repeatBtnSize: 30,shuffleBtnSize: 30,)
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
                  if(widget.player.hasPrevious){
                    widget.player.seekToPrevious();
                  }
                } else if (details.delta.dx < -sensitivity){
                  if(widget.player.hasNext){
                    widget.player.seekToNext();
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
                              HomeScreen.audioQueueSongData[snapshot.data!]["image"][2]["link"],
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
                                    PlayerController(widget.player, isFullScreen: true,nextBtnSize: 30,playPauseBtnSize: 50,prevBtnSize: 30,repeatBtnSize: 30,shuffleBtnSize: 30,),
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
