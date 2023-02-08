// ignore_for_file: use_build_context_synchronously

import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    MediaQueryData device =  MediaQuery.of(context);
    return StreamBuilder(
        stream: mainAudioPlayer.currentIndexStream,
        builder:(context,AsyncSnapshot<int?> snapshot){
          if(snapshot.data != null){
            Map songData = mainAudioPlayer.audioSource!.sequence[snapshot.data!].tag.extras;
            String hasLyrics = songData["hasLyrics"];
            late dynamic localImage;
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
              return Material(
                borderRadius: BorderRadius.circular(8),
                elevation: 80,
                child: Container(
                  width: device.orientation == Orientation.portrait ?  device.size.width*0.85 : device.size.height*0.75 ,
                  height: device.orientation == Orientation.portrait ?  device.size.width*0.85 : device.size.height*0.75 ,
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
                ),
              );
            }
            Widget songName(){
              return Text(htmlDecode.convert(songData["name"]),style: const TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,);
            }
            Widget songArtists(){
              return Text(htmlDecode.convert(songData["primaryArtists"]),style: const TextStyle(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.w500),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis);
            }
            Widget enlargeLyrics(Map lyrics){
              if(hasLyrics == "true") {
                return Material(
                  borderRadius: BorderRadius.circular(999),
                  color: Colors.blue[400],
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: ()async{
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => ShowLyrics(lyrics:lyrics,)
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child:Icon(Icons.zoom_out_map_rounded,size: 25,color: Colors.white,),
                    ),
                  ),
                );
              } else {
                return const SizedBox(height: 0,);
              }
            }
            Widget copyLyrics(String lyrics){
              if(hasLyrics == "true") {
                return Material(
                  borderRadius: BorderRadius.circular(999),
                  color: Colors.blue[400],
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: lyrics));
                      Fluttertoast.showToast(
                          msg: "Copied",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                          timeInSecForIosWeb: 1,
                          backgroundColor: HexColor("222222"),
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child:Icon(Icons.copy_rounded,size: 25,color: Colors.white,),
                    ),
                  ),
                );
              } else {
                return const SizedBox(height: 0,);
              }
            }
            Widget lyricsContainer(){
              return Material(
                borderRadius: BorderRadius.circular(8),
                color: HexColor("121212"),
                elevation: 10,
                child: Container(
                  height: device.size.height*0.5,
                  width: device.size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FutureBuilder(
                      future:HelperFunctions.fetchLyrics(songData["id"]),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                        if(snapshot.hasData){
                          return Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 18,),
                                  const Text("Lyrics",style: TextStyle(
                                    wordSpacing: 2.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                    height: 1.5,
                                  ),),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: copyLyrics(snapshot.data["data"]["lyrics"]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: enlargeLyrics(snapshot.data),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                child: SizedBox(
                                  height: device.size.height*0.42,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text(snapshot.data["data"]["lyrics"] ?? "Not Available",
                                          style: const TextStyle(
                                            wordSpacing: 2.0,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22,
                                            height: 1.5,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                      }else{
                          return const Center(
                            child: SpinKitRipple(
                              color: Colors.white,
                              size: 40,
                            ),
                          );
                        }
                      }
                  )
                ),
              );
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
            Widget playerControlsBlock(){
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: device.orientation == Orientation.portrait ? device.size.height*0.4 : device.size.width*0.6,
                  maxHeight: device.size.height*0.4,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Text(songData["copyright"] ?? "",style: const TextStyle(color: Colors.white70,fontSize: 12,fontWeight: FontWeight.w500),textAlign: TextAlign.center,maxLines: 3,overflow: TextOverflow.ellipsis),
                      PlayerController(mainAudioPlayer, isFullScreen: true,nextBtnSize: 30,playPauseBtnSize: 45,prevBtnSize: 30,repeatBtnSize: 30,shuffleBtnSize: 30,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 0),
                        child: songTimers(),
                      ),
                    ],
                  ),
                ),
              );
            }
            Widget pageContents(){
              return ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                    child: device.orientation == Orientation.portrait ?
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          songCover(),
                          const Spacer(),
                          songName(),
                          const SizedBox(height: 10,),
                          songArtists(),
                          const Spacer(),
                          playerControlsBlock(),
                          if(hasLyrics != "true")
                          const Spacer(),
                          if(hasLyrics == "true") ...[
                            const SizedBox(height: 20,),
                            lyricsContainer(),
                            const Spacer(),
                          ]
                        ],
                      ),
                    )
                        :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        songCover(),
                        const Spacer(),
                        SizedBox(
                          width: device.size.width*0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              songName(),
                              const SizedBox(height: 5,),
                              songArtists(),
                              const Spacer(),
                              const SizedBox(height: 10,),
                              PlayerController(mainAudioPlayer, isFullScreen: true,nextBtnSize: 30,playPauseBtnSize: 50,prevBtnSize: 30,repeatBtnSize: 30,shuffleBtnSize: 30,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 0),
                                child: songTimers(),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
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
                  minChildSize: 0.999999,
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
                      child: hasLyrics == "true" && device.orientation != Orientation.landscape ? ListView(
                        controller: controller,
                        children: [
                          SizedBox(
                              height: device.size.height + device.size.height*0.4,
                              child: pageContents()
                          ),
                        ],
                      ):pageContents(),
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
                    if(hasLyrics == "true"){
                      return page();
                    }
                    else {
                      return page();
                    }
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
