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
  Widget label(String name , {FontWeight? fontWeight , double? fontSize,Color? fontColor,double? hPadding,double? vPadding}) =>  Padding(
    padding: EdgeInsets.symmetric(horizontal: hPadding ?? 15,vertical:vPadding ?? 15),
    child: Text(name,style: TextStyle(fontSize:fontSize ?? 19,fontWeight: fontWeight ?? FontWeight.w600,color: fontColor ?? Colors.white),textAlign: TextAlign.start,),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const SizedBox(height: 50,),
              if(foldersWithArt.isNotEmpty) ...[
                label("Albums" , fontSize: 40),
                label("All Albums on device (${foldersWithArt.length})",fontColor: Colors.white70 , hPadding: 15 , vPadding: 0),
                const SizedBox(height: 5,),
                gridViewRenderer(foldersWithArt),
              ],
              if(foldersWithNoArt.isNotEmpty) ...[
                 Divider(
                  color: HexColor("222222"),
                  thickness: 1,
                  height: 90,
                  // endIndent: 30,
                  // indent: 30,
                ),
                label("Audio files",fontSize: 40,vPadding: 0),
                label("Audio files on device (${foldersWithNoArt.length})",fontSize: 20 , fontColor: Colors.white70),
                const SizedBox(height: 20,),
                listViewRenderer(foldersWithNoArt),
              ],
              const SizedBox(height: 70,)
            ],
          ):
          const Center(child: Text("No user playlists/albums found.",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w400),textAlign: TextAlign.center,)),
          HelperFunctions.collapsedPlayer()
        ],
      ),
    );
  }
}
