import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proto_music_player/screens/app_router_screen.dart';
import 'package:proto_music_player/screens/home_screen.dart';

import '../components/player_buttons.dart';
import '../components/song_tile.dart';
import '../screens/full_player_screen.dart';

class HelperFunctions{
  static Future<Map> getSongByName(String query,int limit)async{
    try{
      String apiEndPoint = "https://saavn-api-weld.vercel.app/search/songs?query=${query.replaceAll(" ", "+")}&page=1&limit=$limit";
      Uri url = Uri.parse(apiEndPoint);
      Response response = await get(url);
      final data = jsonDecode(response.body) as Map<dynamic,dynamic>;
      return data;
    }catch(e){
      if (kDebugMode) {
        print("getSongByName method error: $e");
      }
      return {
        "error":"unable to fetch data"
      };
    }
  }
  static Future<Map> getSongById(String songId)async{
    try{
      String apiEndPoint = "https://saavn-api-weld.vercel.app/songs?id=$songId";
      Uri url = Uri.parse(apiEndPoint);
      Response response = await get(url);
      final data = jsonDecode(response.body) as Map<dynamic,dynamic>;
      return data;
    }catch(e){
      if (kDebugMode) {
        print("getSongById method error: $e");
      }
      return {
        "error":"unable to fetch data"
      };
    }
  }
  static Future<Map> getPlaylistById(String playlistId)async{
    try{
      String apiEndPoint = "https://saavn-api-weld.vercel.app/playlists?id=$playlistId";
      Uri url = Uri.parse(apiEndPoint);
      Response response = await get(url);
      final data = jsonDecode(response.body) as Map<dynamic,dynamic>;
      return data;
    }catch(e){
      if (kDebugMode) {
        print("getPlaylistById method error: $e");
      }
      return {
        "error":"unable to fetch data"
      };
    }
  }
  static Future<Map> getAlbumById(String albumId)async{
    try{
      String apiEndPoint = "https://saavn-api-weld.vercel.app/albums?id=$albumId";
      Uri url = Uri.parse(apiEndPoint);
      Response response = await get(url);
      final data = jsonDecode(response.body) as Map<dynamic,dynamic>;
      return data;
    }catch(e){
      if (kDebugMode) {
        print("getAlbumById method error: $e");
      }
      return {
        "error":"unable to fetch data"
      };
    }
  }
  static Future<Map> searchAll(String query) async{
    try{
      String apiEndPoint = "https://saavn-api-weld.vercel.app/search/all?query=${query.replaceAll(" ", "+")}";
      Uri url = Uri.parse(apiEndPoint);
      Response response = await get(url);
      final data = jsonDecode(response.body) as Map<dynamic,dynamic>;
      return data;
    }catch(e){
      if (kDebugMode) {
        print("getAlbumById method error: $e");
      }
      return {
        "error":"unable to fetch data"
      };
    }
  }
  static Future<void> playHttpSong(Map song,AudioPlayer player)async{
    try{
      await AppRouter.queue.insert(0,AudioSource.uri(Uri.parse(song["downloadUrl"][3]["link"])));
      AppRouter.audioQueueSongData.insert(0,song);
      await HelperFunctions.writeSongLyrics(song,false);
      if(!player.playing){
        await player.setAudioSource(AppRouter.queue , initialIndex: 0,initialPosition: Duration.zero);
      }else {
        await player.stop();
        await player.seek(Duration.zero, index: 0);
      }
      await player.play();
    }catch(e){
      if (kDebugMode) {
        print("playHttpSong method error: $e");
      }
    }
  }
  static Future<void> addSongToQueue(Map song,AudioPlayer player)async{
    try{
      await AppRouter.queue.add(AudioSource.uri(Uri.parse(song["downloadUrl"][3]["link"])));
      AppRouter.audioQueueSongData.add(song);
      await HelperFunctions.writeSongLyrics(song,true);
      if(AppRouter.queue.length == 1){
        await player.setAudioSource(AppRouter.queue , initialIndex: 0);
        await player.play();
      }
    }catch(e){
      if (kDebugMode) {
        print("addSongToQueue method error: $e");
      }
    }
  }
  static Future<void> playGivenListOfSongs(List songs)async{
    try{
      List<AudioSource> givenList = [];
      List givenSongsData = [];
      for(Map song in songs){
        givenList.add(AudioSource.uri(Uri.parse(song["downloadUrl"][3]["link"])));
        Map lyrics = await HelperFunctions.fetchLyrics(song["id"]);
        if(lyrics["data"] != null && lyrics["message"] == null){
          song["lyrics"] = lyrics["data"]["lyrics"];
          song["lyricsCopyRight"] = lyrics["data"]["copyright"];
        }
        givenSongsData.add(song);
      }
      await AppRouter.queue.insertAll(0,givenList);
      AppRouter.audioQueueSongData.insertAll(0, givenSongsData);
      if(AppRouter.queue.length == songs.length){
        await mainAudioPlayer.setAudioSource(AppRouter.queue , initialIndex: 0);
        await mainAudioPlayer.play();
      }
      if(!mainAudioPlayer.playing){
        mainAudioPlayer.play();
      }
    }catch(e){
      if (kDebugMode) {
        print("playGivenListOfSongs method error : $e");
      }
    }
  }

  static Future<void> writeSongLyrics(Map song,bool isLast ,{int? pos})async{
    try{
      int index = isLast ? AppRouter.queue.length - 1 : 0;
      if(song["hasLyrics"] == "true"){
        Map lyrics = await HelperFunctions.fetchLyrics(song["id"]);
        if(lyrics["data"] != null && lyrics["message"] == null){
          AppRouter.audioQueueSongData[pos ?? index]["lyrics"] = lyrics["data"]["lyrics"];
          AppRouter.audioQueueSongData[pos ?? index]["lyricsCopyRight"] = lyrics["data"]["copyright"];
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<Map> fetchLyrics (String songId)async{
    try{
      String apiEndPoint = "https://saavn.me/lyrics?id=$songId";
      Uri url = Uri.parse(apiEndPoint);
      Response response = await get(url);
      final data = jsonDecode(response.body) as Map<dynamic,dynamic>;
      return data;
    }catch(e){
      if (kDebugMode) {
        print("fetchLyrics method error: $e");
      }
      return {
        "error":"unable to fetch data"
      };
    }
  }
  static bool checkIfAddedInQueue(String songId){
    for(Map songData in AppRouter.audioQueueSongData){
      if(songData.values.contains(songId)){
        return true;
      }
    }
    return false;
  }
  static Future<void> removeFromQueue(Map song)async{
    int index = 0;
    for(Map song in AppRouter.audioQueueSongData){
      if(song.values.contains(song["id"])){
        break;
      }
      index++;
    }
    await AppRouter.queue.removeAt(index);
    AppRouter.audioQueueSongData.remove(song);
  }
  static void showSnackBar(BuildContext buildContext, String txt, int duration,
      {Color? bgColor,String? hexCode}) {
    Color bgNormalColor = Colors.red;
    if(bgColor != null){
      bgNormalColor = bgColor;
    }
    ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
      content: SizedBox(
        width: MediaQuery.of(buildContext).size.width * 0.80,
        child: AutoSizeText(
          txt,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 7,
        ),
      ),
      backgroundColor: hexCode != null ? HexColor(hexCode):bgNormalColor,
      shape: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.transparent)
      ),
      duration: Duration(milliseconds: duration),
    ));
  }
  static String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
  static Widget collapsedPlayer(){
    HtmlUnescape htmlDecode = HtmlUnescape();

    return StreamBuilder<PlayerState>(
      stream: mainAudioPlayer.playerStateStream,
      builder: (_, snapshot) {
        final playerState = snapshot.data;
        if(playerState != null) {
          return Positioned(
            bottom: 0,
            child: StreamBuilder(
              stream: mainAudioPlayer.currentIndexStream,
              builder:(context,snapshot){
                if(snapshot.data != null && AppRouter.queue.length != 0){
                  return GestureDetector(
                      onPanUpdate:  (details) {
                        int sensitivity = 8;
                        if (details.delta.dy > sensitivity) {
                          // Down Swipe
                        } else if(details.delta.dy < -sensitivity && AppRouter.audioQueueSongData.isNotEmpty){
                          // Up Swipe
                          showModalBottomSheet(
                              context: context,
                              elevation: 0,
                              barrierColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (context) => const ShowFullPlayer()
                          );
                        }
                      },
                      child : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18)),
                            color: HexColor("111111")
                          ),
                          child:Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  showModalBottomSheet(
                                      context: context,
                                      elevation: 0,
                                      barrierColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (context) => const ShowFullPlayer()
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(AppRouter.audioQueueSongData[snapshot.data!]["image"][1]["link"],height: 55,width: 55,),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    showModalBottomSheet(
                                        context: context,
                                        elevation: 0,
                                        barrierColor: Colors.transparent,
                                        isScrollControlled: true,
                                        builder: (context) => const ShowFullPlayer()
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(htmlDecode.convert(AppRouter.audioQueueSongData[snapshot.data!]["name"]),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 1,),
                                      const SizedBox(height: 5,),
                                      Text(htmlDecode.convert(AppRouter.audioQueueSongData[snapshot.data!]["primaryArtists"]),style: const TextStyle(color: Colors.white70,fontWeight: FontWeight.w500,fontSize: 11),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 2,)
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: PlayerController(mainAudioPlayer, isFullScreen: false,nextBtnSize: 20,playPauseBtnSize: 40,prevBtnSize: 20,repeatBtnSize: 20,shuffleBtnSize: 20,)
                              ),
                            ],
                          )
                      )
                  );
                } else {
                  return const SizedBox(height: 0,);
                }
              },
            ),
          );
        }else {
          return const SizedBox(height: 0,width: 0,);
        }
      },
    );
  }
  static Widget listViewRenderer(List<SongResultTile> list,{required double verticalGap}){
    if(list.isNotEmpty){
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context,index){
          return Padding(
            padding: EdgeInsets.symmetric(vertical: verticalGap),
            child: list[index],
          );
        },
      );
    }else{
      return const Text("no results",style: TextStyle(color: Colors.white),);
    }
  }
  static Widget gridViewRenderer(List list,{required double horizontalPadding ,
    required double verticalPadding , required int crossAxisCount ,
    required double crossAxisSpacing
  }){
    if(list.isNotEmpty){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 5),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: list[index],
            );
          }, gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 10),
        ),
      );
    }else{
      return const Text("no results",style: TextStyle(color: Colors.white),);
    }
  }
}