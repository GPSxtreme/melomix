import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:proto_music_player/models/local_song_data.dart';
import '../screens/app_router_screen.dart';
import '../services/helper_functions.dart';

class OfflineSongTile extends StatefulWidget {
  const OfflineSongTile({Key? key, required this.song}) : super(key: key);
  final SongModel song;
  @override
  State<OfflineSongTile> createState() => _OfflineSongTileState();
}

class _OfflineSongTileState extends State<OfflineSongTile> {
  Random random = Random();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 30,
        child: Stack(
          children: [
            QueryArtworkWidget(
              artworkHeight: 55,
              artworkWidth: 55,
              size: 150,
              id: widget.song.id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: CircleAvatar(
                radius: 30,
                backgroundColor:Colors.accents.elementAt(widget.song.id % Colors.accents.length).withOpacity(0.8),
                child: const Icon(Icons.music_note,color: Colors.white,),
              ),
            ),
            Center(
              child: StreamBuilder(
                stream: mainAudioPlayer.currentIndexStream,
                builder: (buildContext, AsyncSnapshot<int?> snapshot){
                  return StreamBuilder(
                    stream: mainAudioPlayer.playingStream,
                    builder: (buildContext,AsyncSnapshot<bool> state){
                      final isPlaying = state.data;
                      if(isPlaying != null &&
                          isPlaying
                          && snapshot.hasData &&
                          mainAudioPlayer.audioSource!.sequence[snapshot.data!].tag.extras["intId"] == widget.song.id){
                        return const SpinKitWave(color: Colors.white70,size: 33,);
                      }
                      return const SizedBox();
                    },
                  );
                },
              ),
            ),
        ]
        ),
      ),
      title: Text(widget.song.displayNameWOExt,style: const TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),maxLines: 2,overflow: TextOverflow.ellipsis,),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(widget.song.artist ?? "",style: const TextStyle(color: Colors.white70,fontSize: 13,fontWeight: FontWeight.w500),maxLines: 2,overflow: TextOverflow.ellipsis,),
      ),
      onTap: ()async{
        Uint8List? bytes =  await HelperFunctions.getLocalSongArtworkUri(widget.song.id);
        LocalSongData songData = LocalSongData(
            isLocal: true,
            id: widget.song.id.toString(),
            intId: widget.song.id,
            songUri: widget.song.uri,
            name: widget.song.displayNameWOExt,
            albumName: widget.song.album,
            primaryArtists: widget.song.artist,
            artworkBytes: bytes
        );
        HelperFunctions.playLocalSong(songData, mainAudioPlayer);
      },
    );
  }
}
