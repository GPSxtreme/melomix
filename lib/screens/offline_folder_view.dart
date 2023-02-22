import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:proto_music_player/components/offline_song_tile.dart';
import 'package:proto_music_player/services/helper_functions.dart';
import '../models/local_song_data.dart';
import 'app_router_screen.dart';

class OfflineFolderView extends StatefulWidget {
  const OfflineFolderView({Key? key,required this.folderModel}) : super(key: key);
  final AlbumModel folderModel;
  @override
  State<OfflineFolderView> createState() => _OfflineFolderViewState();
}

class _OfflineFolderViewState extends State<OfflineFolderView> {
  final audioQuery = OnAudioQuery();
  bool play = false;
  bool isLoading = false;
  bool isFetching = true;
  List<LocalSongData> songs = [];
  List<SongModel> fetchedSongs = [];
  late bool isAddedToQueue;
  late int firstSongIndexInQueue;
  DecorationImage? albumArt;
  @override
 initState(){
    // TODO: implement initState
    super.initState();
    fetchAllSongs();
  }

  fetchAllSongs()async{
    if(mounted){
      final img = await HelperFunctions.getLocalAlbumArtworkImage(widget.folderModel.id);
      if(img != null){
        albumArt = DecorationImage(
            image: img,
            fit: BoxFit.fill
        );
      }else{
        albumArt = null;
      }
      fetchedSongs = await audioQuery.queryAudiosFrom(
          AudiosFromType.ALBUM_ID,
          widget.folderModel.id,
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          ignoreCase: true
      );
      for(SongModel song in fetchedSongs){
        isAddedToQueue = HelperFunctions.checkIfAddedInQueue(song.id.toString());
        Uint8List? bytes = await HelperFunctions.getLocalSongArtworkUri(song.id);
        LocalSongData songData = LocalSongData(
            isLocal: true,
            id: song.id.toString(),
            intId: song.id,
            songUri: song.uri,
            name: song.displayNameWOExt,
            albumName: song.album,
            primaryArtists: song.artist,
            artworkBytes: bytes
        );
        songs.add(songData);
      }
      await updateFirstSongIndex();
      setState(() {
        isFetching = false;
      });
    }
  }

  updateFirstSongIndex()async{
    firstSongIndexInQueue = await HelperFunctions.getQueueIndexBySongId(songs[0].id);
  }

  Widget allSongs(){
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: fetchedSongs.length,
      itemBuilder: (context,index){
        return OfflineSongTile(song: fetchedSongs[index]);
      },
    );
  }

  bool doesBelong(){
    try{
      //checks whether current playing song belongs to album;
      if (kDebugMode) {
        print("offline model : current index : ${mainAudioPlayer.currentIndex!} , first song index : $firstSongIndexInQueue , queue len :${AppRouter.queue.length}");
      }
      if(firstSongIndexInQueue != -1 && mainAudioPlayer.currentIndex! >= firstSongIndexInQueue &&
          songs[mainAudioPlayer.currentIndex! - firstSongIndexInQueue].id == mainAudioPlayer.sequence![mainAudioPlayer.currentIndex!].tag.extras["id"]){
        //does belong
        return true;
      }
      //does not belong
      return false;
    }catch(e){
      if (kDebugMode) {
        print("offline model : checker error : $e");
      }
      //error
      return false;
    }
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
        await HelperFunctions.playGivenListOfLocalSongs(songs);
      }
    }
  }

  Widget playPauseButton(AudioPlayer player, PlayerState playerState ,double iconSize) {
    final processingState = playerState.processingState;
    //albums first song index
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering || isLoading) {
      return SpinKitRipple(
        color: Colors.white,
        size: iconSize,
      );
    } else if (!player.playing|| (processingState != ProcessingState.completed) || (!doesBelong() && processingState == ProcessingState.completed)) {
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
            Icons.play_arrow_sharp,color:Colors.white,
            size: iconSize,
          ),
        );
      }
      else{
        //pause button is returned when player is playing
        return GestureDetector(
          onTap:()async{
            await mainAudioPlayer.pause();
          },
          child: Icon(
            Icons.pause_outlined,color:  Colors.white,
            size: iconSize,
          ),
        );
      }
    } else {
      return GestureDetector(
        onTap:() =>player.seek(Duration.zero,
            index: firstSongIndexInQueue
        ),
        child: Icon(
          Icons.replay,color:Colors.white,
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
            isFetching ?
                const Center(
                    child: SpinKitRipple(color: Colors.white,size: 80,)
                ):
            ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.accents.elementAt(widget.folderModel.id % Colors.accents.length).withOpacity(0.8),
                    image: albumArt
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
                                  Colors.black.withOpacity(0.2),
                                  Colors.black.withOpacity(0.5),
                                  Colors.black.withOpacity(1),
                                ],
                                stops:const [
                                  0.0,
                                  0.3,
                                  0.8,
                                  1.0
                                ])
                      ),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20,),
                                Center(
                                  child: Material(
                                    elevation: 10,
                                    child: Container(
                                      height: 220,
                                      width: 220,
                                      color: Colors.accents.elementAt((widget.folderModel.id - 1) % Colors.accents.length).withOpacity(0.8),
                                      child: QueryArtworkWidget(
                                        artworkFit: BoxFit.fill,
                                        size: 1000,
                                        artworkHeight: 220,
                                        artworkWidth: 220,
                                        artworkBorder: BorderRadius.circular(0),
                                        id: widget.folderModel.id,
                                        type: ArtworkType.ALBUM,
                                        nullArtworkWidget: const Icon(Icons.multitrack_audio_rounded,color: Colors.white,size: 60,)
                                      ) ,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20,),
                                      Text(
                                        widget.folderModel.album.trim(),
                                        style: const TextStyle(color: Colors.white,fontSize:25,fontWeight: FontWeight.w800),
                                        textAlign: TextAlign.start,
                                        overflow:TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 15,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.folderModel.artist ?? "",
                                                  style: const TextStyle(color: Colors.white60,fontSize: 18,fontWeight: FontWeight.w700),
                                                  textAlign: TextAlign.start,
                                                  overflow:TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                ),
                                                const SizedBox(height: 15,),
                                                Text(
                                                  widget.folderModel.numOfSongs.toString(),
                                                  style: const TextStyle(color: Colors.white60,fontSize: 18,fontWeight: FontWeight.w700),
                                                  textAlign: TextAlign.center,
                                                  overflow:TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Material(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(999),
                                            child: InkWell(
                                              onTap: (){},
                                              borderRadius: BorderRadius.circular(999),
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: StreamBuilder(
                                                  stream: mainAudioPlayer.playerStateStream,
                                                  builder: (_,AsyncSnapshot<PlayerState> snapshot){
                                                    if(snapshot.hasData){
                                                      return playPauseButton(mainAudioPlayer, snapshot.data!, 45);
                                                    }else{
                                                      return const SizedBox(height: 0,width: 0,);
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 8,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ),
                  ),
                ),
                ),
                //All rendered songs
                allSongs(),
                const SizedBox(height: 70,)
              ],
            ),
            HelperFunctions.collapsedPlayer()
          ],
        ),
      ),
    );
  }
}
