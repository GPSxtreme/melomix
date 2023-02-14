import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:proto_music_player/components/offline_folder_tile.dart';
import 'package:proto_music_player/components/offline_list_view_tile.dart';
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
  bool isLoaded = false;
  List<AlbumModel> allFolders = [];
  List<AlbumModel> foldersWithArt = [];
  List<AlbumModel> foldersWithNoArt = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllFolders();
  }
  fetchAllFolders()async{
    try{
      allFolders = await audioQuery.queryAlbums();
      //separate albums based on artwork availability.
      for(AlbumModel folder in allFolders){
        bool hasArtwork = await HelperFunctions.hasAlbumArtwork(folder.id);
        if(hasArtwork){
          foldersWithArt.add(folder);
        }else{
          foldersWithNoArt.add(folder);
        }
      }
    }catch(e){
      if(kDebugMode){
        print("my_playlists_screen error: $e");
      }
    }finally{
      setState(() {
        isLoaded = true;
      });
    }
  }
  Widget gridViewRenderer(List folder){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GridView.builder(
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 15,mainAxisSpacing: 15),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: folder.length,
        itemBuilder: (context,index){
          return OfflineFolderTile(folderModel: folder[index],);
        },
      ),
    );
  }
  Widget listViewRenderer(List folder){
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: folder.length,
      itemBuilder: (context,index){
        return OfflineListViewTile(folderModel: folder[index],);
      },
    );
  }
  Widget label(String text){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: Container(
          decoration: BoxDecoration(
              color: HexColor("222222"),
              borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
              padding:const EdgeInsets.symmetric(vertical: 16,horizontal: 8),
              child: Text(text,style: const TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w600),)
          )
      ),
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
            !isLoaded ?
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SpinKitRipple(color: Colors.white,size: 60,),
                  SizedBox(height: 20,),
                  Text("Hold tight this might take some time.",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w400),textAlign: TextAlign.center,)
                ],
              ),
            ):
            allFolders.isNotEmpty ?
            ListView(
              children: [
                const SizedBox(height: 10,),
                if(foldersWithArt.isNotEmpty) ...[
                  label("All Albums on device (${foldersWithArt.length})"),
                  gridViewRenderer(foldersWithArt),
                ],
                if(foldersWithNoArt.isNotEmpty) ...[
                  label("Other audio files on device (${foldersWithNoArt.length})"),
                  listViewRenderer(foldersWithNoArt),
                ],
                const SizedBox(height: 70,)
              ],
            ):
            const Center(child: Text("No user playlists/albums found.",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w400),textAlign: TextAlign.center,)),
            HelperFunctions.collapsedPlayer()
          ],
        ),
      ),
    );
  }
}
