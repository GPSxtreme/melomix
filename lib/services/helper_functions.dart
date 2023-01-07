import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:proto_music_player/screens/app_router_screen.dart';
import '../components/player_buttons.dart';
import '../components/online_song_tile.dart';
import '../screens/full_player_screen.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'dart:io';
import 'package:just_audio_background/just_audio_background.dart';

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
      HtmlUnescape htmlDecode = HtmlUnescape();
      //check if song already exists in queue
      if(checkIfAddedInQueue(song["id"])){
        int existingSongIndex = await getQueueIndexBySongId(song["id"]);
        await player.seek(Duration.zero, index: existingSongIndex);
      }else{
        await AppRouter.queue.insert(0,AudioSource.uri(Uri.parse(song["downloadUrl"][3]["link"]),tag: MediaItem(
          // Specify a unique ID for each media item:
          id: '${song["id"]}',
          // Metadata to display in the notification:
          album: htmlDecode.convert(song["album"]["name"]),
          title: htmlDecode.convert(song["name"]),
          artUri: Uri.parse(song["image"][1]["link"]),
          extras: song as Map<String,dynamic>
        )));
        if(player.audioSource == null){
          await player.setAudioSource(AppRouter.queue , initialIndex: 0,initialPosition: Duration.zero);
        }else {
          await player.seek(Duration.zero, index: 0);
        }
        await player.play();
      }
    }catch(e){
      if (kDebugMode) {
        print("playHttpSong method error: $e");
      }
    }
  }
  static Future<void> addSongToQueue(Map song,AudioPlayer player)async{
    try{
      HtmlUnescape htmlDecode = HtmlUnescape();
      await AppRouter.queue.add(AudioSource.uri(Uri.parse(song["downloadUrl"][3]["link"]),tag: MediaItem(
        // Specify a unique ID for each media item:
          id: '${song["id"]}',
          // Metadata to display in the notification:
          album: htmlDecode.convert(song["album"]["name"]),
          title: htmlDecode.convert(song["name"]),
          artUri: Uri.parse(song["image"][1]["link"]),
          extras: song as Map<String,dynamic>
      )));
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
      HtmlUnescape htmlDecode = HtmlUnescape();
      List<AudioSource> givenList = [];
      List givenSongsData = [];
      for(Map song in songs){
        givenList.add(AudioSource.uri(Uri.parse(song["downloadUrl"][3]["link"]),tag: MediaItem(
          // Specify a unique ID for each media item:
            id: '${song["id"]}',
            // Metadata to display in the notification:
            album: htmlDecode.convert(song["album"]["name"]),
            title: htmlDecode.convert(song["name"]),
            artUri: Uri.parse(song["image"][1]["link"]),
            extras: song as Map<String,dynamic>
        )));
        givenSongsData.add(song);
      }
      await AppRouter.queue.insertAll(0,givenList);
      if(AppRouter.queue.length == songs.length){
        await mainAudioPlayer.setAudioSource(AppRouter.queue , initialIndex: 0);
        await mainAudioPlayer.play();
      }
      mainAudioPlayer.seek(Duration.zero,index: 0);
      mainAudioPlayer.play();
    }catch(e){
      if (kDebugMode) {
        print("playGivenListOfSongs method error : $e");
      }
    }
  }

  static Future<int> getQueueIndexBySongId(String songId)async{
    if(mainAudioPlayer.sequence != null){
      for(int i = 0 ; i < mainAudioPlayer.sequence!.length ; i++){
        if(mainAudioPlayer.audioSource!.sequence[i].tag.extras["id"] == songId) return i;
      }
    }
    return -1;
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
    if( mainAudioPlayer.sequence != null && mainAudioPlayer.sequence!.isNotEmpty && mainAudioPlayer.audioSource != null){
      for(int i = 0 ; i < mainAudioPlayer.sequence!.length ; i++){
        if(mainAudioPlayer.audioSource!.sequence[i].tag.extras["id"] == songId) return true;
      }
    }
    return false;
  }

  static Future<void> removeFromQueue(Map song)async{
    int index = 0;
    for(int i = 0 ; i < mainAudioPlayer.sequence!.length ; i++){
      if(mainAudioPlayer.audioSource!.sequence[i].tag.extras["id"] == song["id"]) break;
    }
    await AppRouter.queue.removeAt(index);
  }

  static void showSnackBar(BuildContext buildContext, String txt, int duration,
      {Color? bgColor,String? hexCode})
  {
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
    Random random = Random();
    return StreamBuilder<PlayerState>(
      stream: mainAudioPlayer.playerStateStream,
      builder: (_, snapshot) {
        final playerState = snapshot.data;
        if(playerState != null) {
          return Positioned(
            bottom: 0,
            child: StreamBuilder(
              stream: mainAudioPlayer.currentIndexStream,
              builder:(context,AsyncSnapshot<int?> currentIndex){
                if(currentIndex.data != null && AppRouter.queue.length != 0){
                  Map songData = mainAudioPlayer.audioSource!.sequence[currentIndex.data!].tag.extras;
                  return GestureDetector(
                      onPanUpdate:  (details) {
                        int sensitivity = 8;
                        if (details.delta.dy > sensitivity) {
                          // Down Swipe
                        } else if(details.delta.dy < -sensitivity){
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
                                  child: songData["isLocal"] != null && songData["isLocal"] ?
                                      (
                                          songData["artworkBytes"] != null ?
                                      Image.memory(songData["artworkBytes"] , height: 55,width: 55,) :
                                          CircleAvatar(
                                            backgroundColor:Colors.accents.elementAt(random.nextInt(Colors.accents.length)).withOpacity(0.8),
                                            child: const Icon(Icons.music_note,color: Colors.white,),
                                          )
                                      )
                                  :
                                  Image.network(songData["image"][1]["link"],height: 55,width: 55,),
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
                                      Text(htmlDecode.convert(songData["name"]),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 1,),
                                      const SizedBox(height: 5,),
                                      Text(htmlDecode.convert(songData["primaryArtists"]),style: const TextStyle(color: Colors.white70,fontWeight: FontWeight.w500,fontSize: 11),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 2,)
                                    ],
                                  ),
                                ),
                              ),
                              PlayerController(mainAudioPlayer, isFullScreen: false,nextBtnSize: 20,playPauseBtnSize: 40,prevBtnSize: 20,repeatBtnSize: 20,shuffleBtnSize: 20,),
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

  static Widget listViewRenderer(List<OnlineSongResultTile> list,{required double verticalGap}){
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

  static Widget label(String name , {required double horizontalPadding , required verticalPadding , double? fontSize}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ,vertical: verticalPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:  [
              Text(name,style:TextStyle(fontSize: fontSize ?? 18,fontWeight: FontWeight.w500,color: Colors.white),textAlign: TextAlign.start,),
            ],
          ),
        ],
      ),
    );
  }


  //(not needed/not used/might be useful in future)
  static Future<Map> getMetadata(String songPath) async {
    final metadata = await MetadataRetriever.fromFile(File(songPath));
    return metadata.toJson();
  }
  //Local media songs methods
  //get local media art work
  static Future<Uint8List?> getLocalSongArtworkUri(int songId)async{
    final audioQuery = OnAudioQuery();
    Uint8List? bytes =  await  audioQuery.queryArtwork(songId, ArtworkType.AUDIO);
    return bytes;
  }
  static Future<dynamic> getLocalSongArtworkImage(int songId)async{
    final audioQuery = OnAudioQuery();
    Uint8List? bytes =  await  audioQuery.queryArtwork(songId, ArtworkType.AUDIO,quality: 400,format: ArtworkFormat.JPEG,size: 1000);
    if(bytes != null){
      return Image.memory(bytes,filterQuality: FilterQuality.high,).image;
    }
    return false;
  }
  //play local media song
  static Future<void> playLocalSong(Map song,AudioPlayer player)async{
    try{
      // check if song already exists in queue
      if(checkIfAddedInQueue(song["id"])){
        int existingSongIndex = await getQueueIndexBySongId(song["id"]);
        await player.seek(Duration.zero, index: existingSongIndex);
      }
      else{
        await AppRouter.queue.insert(0,AudioSource.uri(Uri.parse(song["songUri"]),tag: MediaItem(
            id: song["id"].toString(),
            album: song["albumName"],
            title: song["name"],
            // artUri: cant determine :(,
            extras: song as Map<String,dynamic>
        )));
        if(player.audioSource == null){
          await player.setAudioSource(AppRouter.queue , initialIndex: 0,initialPosition: Duration.zero);
        }else {
          await player.seek(Duration.zero, index: 0);
        }
      }
      await player.play();
    }catch(e){
      if (kDebugMode) {
        print("playLocalSong method error: $e");
      }
    }
  }

}