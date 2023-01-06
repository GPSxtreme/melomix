import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:proto_music_player/screens/app_router_screen.dart';
import '../services/helper_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MyPlaylistsScreen extends StatefulWidget {
  const MyPlaylistsScreen({Key? key}) : super(key: key);
  static String id = "my_playlists_screen";
  @override
  State<MyPlaylistsScreen> createState() => _MyPlaylistsScreenState();
}

class _MyPlaylistsScreenState extends State<MyPlaylistsScreen> {
  final audioQuery = OnAudioQuery();

  Widget label(String name) =>  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 18),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:  [
            Text(name,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white),textAlign: TextAlign.start,),
          ],
        ),
      ],
    ),
  );

  Widget allSongsOnDevice(){
    return FutureBuilder<List<SongModel>>(
      future: audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
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
            return ListTile(
              leading: QueryArtworkWidget(
                id: items.data![index].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: const Icon(Icons.music_note,color: Colors.white,),
              ),
              title: Text(items.data![index].displayNameWOExt,style: const TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),maxLines: 2,overflow: TextOverflow.ellipsis,),
              subtitle: Text(items.data![index].artist,style: const TextStyle(color: Colors.white70,fontSize: 13,fontWeight: FontWeight.w500),maxLines: 2,overflow: TextOverflow.ellipsis,),
              onTap: ()async{
                Uint8List? bytes =  await HelperFunctions.getLocalSongArtworkUri(items.data![index].id);
                Map<String,dynamic> songData = {
                  "isLocal" : true,
                  "id": items.data![index].id.toString(),
                  "intId" : items.data![index].id,
                  "songUri" : items.data![index].uri,
                  "name" : items.data![index].displayNameWOExt,
                  "albumName": items.data![index].album,
                  "primaryArtists" : items.data![index].artist,
                  "hasLyrics" : "false",
                  "artworkBytes" : bytes,
                  "copyright" : ""
                };
                HelperFunctions.playLocalSong(songData, mainAudioPlayer);
              },
            );
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
            //body
            ListView(
              children: [
                label("All songs on device"),
                allSongsOnDevice(),
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
