import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:proto_music_player/components/offline_folder_tile.dart';
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

  

  Widget allFoldersOnDevice(){
    return FutureBuilder<List<AlbumModel>>(
      future: audioQuery.queryAlbums(
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
        return GridView.builder(
          gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10,mainAxisSpacing: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.data!.length < 200 ? items.data!.length : 200,
          itemBuilder: (context,index){
            return OfflineFolderTile(folderModel: items.data![index],);
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
                HelperFunctions.label("All albums on device", horizontalPadding: 20.0, verticalPadding: 18.0 , fontSize: 25),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: allFoldersOnDevice(),
                ),
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
