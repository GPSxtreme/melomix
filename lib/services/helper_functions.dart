import 'dart:convert';
import 'package:audiotagger/models/tag.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:proto_music_player/screens/app_router_screen.dart';
import '../components/player_buttons.dart';
import '../components/online_song_tile.dart';
import '../models/local_song_data.dart';
import '../screens/full_player_screen.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'dart:io';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flowder/flowder.dart';
import 'package:audiotagger/audiotagger.dart';


class HelperFunctions{
  //app dir name
  static String appDir = "storage/emulated/0/proto player";
  static String apiDomain = "https://saavn-api-weld.vercel.app/";

  static Future<Map> getSongByName(String query,int limit)async{
    try{
      String apiEndPoint = "${apiDomain}search/songs?query=${query.replaceAll(" ", "+")}&page=1&limit=$limit";
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
      String apiEndPoint = "${apiDomain}songs?id=$songId";
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
      String apiEndPoint = "${apiDomain}playlists?id=$playlistId";
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
      String apiEndPoint = "${apiDomain}albums?id=$albumId";
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
      String apiEndPoint = "${apiDomain}search/all?query=${query.replaceAll(" ", "+")}";
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
        await AppRouter.queue.insert(0,AudioSource.uri(Uri.parse(song["downloadUrl"][2]["link"]),tag: MediaItem(
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
  static Future<bool> checkIfLocalDirExistsInApp(String path)async{
    // final appDocDir = await getApplicationDocumentsDirectory();
    Directory fileDir = Directory('$appDir/$path/');
    final doesDirExist = await fileDir.exists();
    return doesDirExist;
  }
  static Future<void> createLocalDirInApp(String path)async{
    // final appDocDir = await getApplicationDocumentsDirectory();
    Directory fileDir = Directory('$appDir/$path/');
    await fileDir.create(recursive: true);
  }
  ///Downloads songs artwork
  static Future<void> downloadSongArtwork(String link , String filePath)async{
    try{
      final downloaderUtils = DownloaderUtils(
        progressCallback: (current, total) {
          final progress = (current / total) * 100;
          if (kDebugMode) {
            print('Downloading: $progress');
          }
        },
        file: File(filePath),
        progress: ProgressImplementation(),
        onDone: () async{
          if (kDebugMode) {
            print('online song artwork downloaded');
          }
        },
      );
      await Flowder.download(
          link,
          downloaderUtils
      );
    }catch(e){
      if(kDebugMode){
        print('downloadSongArtwork method error : $e');
      }
    }
  }
  ///get song tags of the given song.
  static Future<Map> getSongTags({required songPath})async{
    final tagger = Audiotagger();
    final Map? tags = await tagger.readTagsAsMap(
        path: songPath
    );
    if(tags != null) {
      return tags;
    } else{
      return {};
    }
  }

  ///Sets song tags to the given song.
  static Future<void> setSongTags({required Map songData, required String songPath , required String imgFilePath})async {
    try{
      HtmlUnescape htmlDecode = HtmlUnescape();
      final tagger = Audiotagger();
      final tags = Tag(
        title: htmlDecode.convert(songData["name"]),
        artist: htmlDecode.convert(songData["primaryArtists"]),
        album: htmlDecode.convert(songData["album"]["name"]),
        id: songData["id"],
        artwork: imgFilePath,
        explicitContent: songData["explicitContent"].toString(),
        hasLyrics: songData["hasLyrics"],
        copyright: songData["copyright"],
        year: songData["year"]
      );
      final isSuccess = await tagger.writeTags(
        path: songPath,
        tag: tags,
      );
      Map songTags = await getSongTags(songPath: songPath);
      if(kDebugMode){
        print(tags.toMap());
        print("isSuccess : $isSuccess");
        print(songTags);
      }
      Future.delayed(const Duration(seconds: 5),()async{
        if(!isSuccess!){
          File song = File(songPath);
          await song.delete();
          // delete artwork file
          File artworkFile = File(imgFilePath);
          await artworkFile.delete();
          if(kDebugMode){
            print("failed and deleted");
          }
        }
      });
    }catch(e){
      if(kDebugMode){
        print('setSongTags method error : $e');
      }
    }
  }
  ///Downloads http songs to device memory with Id3 tags using [setSongTags] function.
  static Future<void> downloadHttpSong({required Map songData})async{
    try{
      HtmlUnescape htmlDecode = HtmlUnescape();
      String link =  songData["downloadUrl"][3]["link"];
      String parentDir = htmlDecode.convert(songData["album"]["name"]);
      String fileName = htmlDecode.convert(songData["name"]);
      bool dirExists = await HelperFunctions.checkIfLocalDirExistsInApp('downloaded songs/$parentDir');
      String filePath = '$appDir/$parentDir/$fileName.mp3';
      String imgFilePath = '$appDir/$parentDir/${fileName}_img.jpg';
      if(!dirExists){
        await HelperFunctions.createLocalDirInApp(parentDir);
      }
      //download song artwork
      await downloadSongArtwork(songData["image"][2]["link"], imgFilePath);
      final downloaderUtils = DownloaderUtils(
        progressCallback: (current, total) {
          final progress = (current / total) * 100;
          if (kDebugMode) {
            print('Downloading: $progress');
          }
        },
        file: File(filePath),
        progress: ProgressImplementation(),
        onDone: () async{
            if (kDebugMode) {
              print('Download done');
              await setSongTags(songData: songData, songPath: filePath , imgFilePath : imgFilePath);
            }
          },
        deleteOnCancel: true,
      );

      await Flowder.download(
          link,
          downloaderUtils
      );
    }catch(e){
      if(kDebugMode){
        print('downloadHttpSong method error : $e');
      }
    }
  }
  ///Returns song index in queue.
  static Future<int> getQueueIndexBySongId(String songId)async{
    if(mainAudioPlayer.sequence != null){
      for(int i = 0 ; i < mainAudioPlayer.sequence!.length ; i++){
        if(mainAudioPlayer.audioSource!.sequence[i].tag.extras["id"] == songId) return i;
      }
    }
    return -1;
  }
  ///Fetches song lyrics.
  static Future<Map> fetchLyrics (String songId)async{
    try{
      String apiEndPoint = "${apiDomain}lyrics?id=$songId";
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
  ///Checks if the given [songId] exists in queue.
  static bool checkIfAddedInQueue(String songId){
    if( mainAudioPlayer.sequence != null && mainAudioPlayer.sequence!.isNotEmpty && mainAudioPlayer.audioSource != null){
      for(int i = 0 ; i < mainAudioPlayer.sequence!.length ; i++){
        if(mainAudioPlayer.audioSource!.sequence[i].tag.extras["id"] == songId) return true;
      }
    }
    return false;
  }
  ///Removes the given song from queue.
  static Future<void> removeFromQueue(Map song)async{
    int index = 0;
    for(int i = 0 ; i < mainAudioPlayer.sequence!.length ; i++){
      if(mainAudioPlayer.audioSource!.sequence[i].tag.extras["id"] == song["id"]) break;
    }
    await AppRouter.queue.removeAt(index);
  }
  ///Formats given [Duration] into a readable song duration.
  static String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
  ///Returns a mini audio player attached to [BottomNavigationBar].
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
                              //song artwork.
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
                                            backgroundColor:Colors.accents.elementAt(songData["intId"] % Colors.accents.length).withOpacity(0.8),
                                            child: const Icon(Icons.music_note,color: Colors.white,),
                                          )
                                      )
                                  :
                                  Image.network(songData["image"][1]["link"],height: 55,width: 55,),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              //song title,song artists.
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
                              //player controller buttons.
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
  ///A standard ListViewRenderer.
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
  ///A standard GridViewRenderer.
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
  ///returns a label widget.
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


  ///get song meta data by its path.
  static Future<Map> getMetadata(String songPath) async {
    final metadata = await MetadataRetriever.fromFile(File(songPath));
    return metadata.toJson();
  }
  //Local media songs methods
  ///get local media art work uri by [songId].
  static Future<Uint8List?> getLocalSongArtworkUri(int songId)async{
    final audioQuery = OnAudioQuery();
    Uint8List? bytes =  await  audioQuery.queryArtwork(songId, ArtworkType.AUDIO);
    return bytes;
  }
  ///get local media art work image by [songId].
  static Future<dynamic> getLocalSongArtworkImage(int songId)async{
    final audioQuery = OnAudioQuery();
    Uint8List? bytes =  await  audioQuery.queryArtwork(songId, ArtworkType.AUDIO,quality: 400,format: ArtworkFormat.JPEG,size: 1000);
    if(bytes != null){
      return Image.memory(bytes,filterQuality: FilterQuality.high,).image;
    }
    return false;
  }
  ///get local media art work image by [songId].
  static Future<dynamic> getLocalAlbumArtworkImage(int albumId)async{
    final audioQuery = OnAudioQuery();
    Uint8List? bytes =  await  audioQuery.queryArtwork(albumId, ArtworkType.ALBUM,quality: 400,format: ArtworkFormat.JPEG,size: 1000);
    if(bytes != null){
      return Image.memory(bytes,filterQuality: FilterQuality.medium,).image;
    }
    return null;
  }

  static Future<Uri> getSongArtworkUri(Uint8List artwork) async {
    String base64Image = base64Encode(artwork);
    String dataUri = 'content://$base64Image';
    Uri imageUri = Uri.parse(dataUri);
    return imageUri;
  }
  ///check if the given album has artwork
  static Future<bool> hasAlbumArtwork(int albumId)async{
    final audioQuery = OnAudioQuery();
    Uint8List? bytes =  await  audioQuery.queryArtwork(albumId, ArtworkType.ALBUM,quality: 1,format: ArtworkFormat.JPEG,size: 1);
    if(bytes != null){
      return true;
    }
    return false;
  }
  ///plays local media song by taking [LocalSongData] as input.
  static Future<void> playLocalSong(LocalSongData song,AudioPlayer player)async{
    try{
      // check if song already exists in queue
      if(checkIfAddedInQueue(song.id)){
        int existingSongIndex = await getQueueIndexBySongId(song.id);
        await player.seek(Duration.zero, index: existingSongIndex);
      }
      else{
        Uri? artUri;
        if(song.artworkBytes != null){
         artUri = await getSongArtworkUri(song.artworkBytes!);
        }
        await AppRouter.queue.insert(0,AudioSource.uri(Uri.parse(song.songUri!),tag: MediaItem(
            id: song.id,
            album: song.albumName,
            title: song.name,
            artUri: artUri,
            extras: song.getMap
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
  ///Plays a given list of type [LocalSongData] and adds them to queue.
  static Future<void> playGivenListOfLocalSongs(List<LocalSongData> songs)async{
    try{
      List<AudioSource> givenList = [];
      List givenSongsData = [];
      for(LocalSongData song in songs){
        givenList.add(AudioSource.uri(Uri.parse(song.songUri!),tag: MediaItem(
          // Specify a unique ID for each media item:
            id: song.id,
            // Metadata to display in the notification:
            album: song.albumName,
            title: song.name ,
            // artUri: cant determine :(,
            extras: song.getMap
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
        print("playGivenListOfLocalSongs method error : $e");
      }
    }
  }
}