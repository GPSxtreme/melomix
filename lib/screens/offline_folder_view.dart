import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:proto_music_player/components/offline_song_tile.dart';
import 'package:proto_music_player/services/helper_functions.dart';

class OfflineFolderView extends StatefulWidget {
  const OfflineFolderView({Key? key, required this.folderId}) : super(key: key);
  final int folderId;
  @override
  State<OfflineFolderView> createState() => _OfflineFolderViewState();
}

class _OfflineFolderViewState extends State<OfflineFolderView> {
  final audioQuery = OnAudioQuery();

  Widget allSongs(){
    return FutureBuilder<List<SongModel>>(
      future: audioQuery.queryAudiosFrom(
          AudiosFromType.ALBUM_ID,
          widget.folderId,
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          ignoreCase: true
      ),
      builder: (BuildContext context, AsyncSnapshot<dynamic> items) {
        if(items.data == null){
          return const Center(
            heightFactor: 15,
            child: CircularProgressIndicator(color: Colors.white,),
          );
        }
        if(items.data!.isEmpty){
          return const Center(
            heightFactor: 20,
            child: Text("No results found!",style: TextStyle(color: Colors.white,fontSize: 16)),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.data!.length < 200 ? items.data!.length : 200,
          itemBuilder: (context,index){
            return OfflineSongTile(song: items.data![index]);
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ListView(
              children: [
                // HelperFunctions.label("All songs", horizontalPadding: 20.0, verticalPadding: 18.0),
                allSongs()
              ],
            ),
            HelperFunctions.collapsedPlayer()
          ],
        ),
      ),
    );
  }
}
