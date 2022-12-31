import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proto_music_player/screens/proto_home.dart';

class HelperFunctions{
  static Future<Map> querySong(String query,int limit)async{
    String apiEndPoint = "https://saavn.me/search/songs?query=${query.replaceAll(" ", "+")}&page=1&limit=$limit";
    Uri url = Uri.parse(apiEndPoint);
    Response response = await get(url);
    final data = jsonDecode(response.body) as Map<dynamic,dynamic>;
    return data;
  }
  static void playHttpSong(String songUrl,AudioPlayer player){
    player.stop();
    player.setUrl(songUrl);
    player.play();
  }
  static void addSongToQueue(String songUrl,AudioPlayer player)async{
    ProtoHome.audioQueue.add(AudioSource.uri(Uri.parse(songUrl)));
    if(ProtoHome.audioQueueItemsList.isEmpty){
      await player.setAudioSource(ProtoHome.audioQueue, initialIndex: 0, initialPosition: Duration.zero);
    }
  }
  static Future<Map> fetchLyrics (String songId)async{
    String apiEndPoint = "https://saavn.me/lyrics?id=$songId";
    Uri url = Uri.parse(apiEndPoint);
    Response response = await get(url);
    final data = jsonDecode(response.body) as Map<dynamic,dynamic>;
    return data;
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
}