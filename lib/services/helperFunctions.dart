import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proto_music_player/screens/home_screen.dart';

class HelperFunctions{
  static Future<Map> querySong(String query,int limit)async{
    String apiEndPoint = "https://saavn.me/search/songs?query=${query.replaceAll(" ", "+")}&page=1&limit=$limit";
    Uri url = Uri.parse(apiEndPoint);
    Response response = await get(url);
    final data = jsonDecode(response.body) as Map<dynamic,dynamic>;
    return data;
  }
  static void playHttpSong(Map song,AudioPlayer player){
    HomeScreen.audioQueueSongData.insert(0,song);
    HomeScreen.queue.insert(0,AudioSource.uri(Uri.parse(song["downloadUrl"][3]["link"])));
    if(!player.playing && HomeScreen.queue.length == 1){
      player.setAudioSource(HomeScreen.queue , initialIndex: 0,initialPosition: Duration.zero);
    }else {
      player.seek(Duration.zero, index: 0);
    }
    player.play();
  }
  static void addSongToQueue(Map song,AudioPlayer player)async{
    HomeScreen.queue.add(AudioSource.uri(Uri.parse(song["downloadUrl"][3]["link"])));
    HomeScreen.audioQueueSongData.add(song);
    if(HomeScreen.queue.length == 1){
      player.setAudioSource(HomeScreen.queue , initialIndex: 0);
      player.play();
    }
  }
  static void writeSongLyrics(Map song,bool isLast)async{
    int index = isLast ? HomeScreen.queue.length-1 : 0;
    if(song["hasLyrics"] == "true"){
      Map lyrics = await HelperFunctions.fetchLyrics(song["id"]);
      if(lyrics["data"] != null){
        HomeScreen.audioQueueSongData[index]["lyrics"] = lyrics["data"]["lyrics"];
        HomeScreen.audioQueueSongData[index]["lyricsCopyRight"] = lyrics["data"]["copyright"];
      }
    }
  }

  static Future<Map> fetchLyrics (String songId)async{
    String apiEndPoint = "https://saavn.me/lyrics?id=$songId";
    Uri url = Uri.parse(apiEndPoint);
    Response response = await get(url);
    final data = jsonDecode(response.body) as Map<dynamic,dynamic>;
    return data;
  }
  static bool checkIfAddedInQueue(String songId){
    for(Map songData in HomeScreen.audioQueueSongData){
      if(songData.values.contains(songId)){
        return true;
      }
    }
    return false;
  }
  static Future<void> removeFromQueue(Map song)async{
    int index = 0;
    for(Map songData in HomeScreen.audioQueueSongData){
      index++;
      if(songData.values.contains(song["id"])){
        break;
      }
    }
    HomeScreen.audioQueueSongData.remove(song);
    await HomeScreen.queue.removeAt(index);
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
}