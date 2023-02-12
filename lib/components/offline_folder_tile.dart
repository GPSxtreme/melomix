import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:proto_music_player/screens/offline_folder_view.dart';
import '../services/helper_functions.dart';

class OfflineFolderTile extends StatefulWidget {
  const OfflineFolderTile({Key? key, required this.folderModel}) : super(key: key);
  final AlbumModel folderModel;
  @override
  State<OfflineFolderTile> createState() => _OfflineFolderTileState();
}

class _OfflineFolderTileState extends State<OfflineFolderTile> {
  DecorationImage? albumArt;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAlbumArt();
  }
  fetchAlbumArt()async{
    if(mounted){
      try{
        final img = await HelperFunctions.getLocalAlbumArtworkImage(widget.folderModel.id);
        if(img != null){
          albumArt = DecorationImage(
              image: img,
              fit: BoxFit.fill
          );
        }else{
          albumArt = null;
        }
      }catch(e){
        if(kDebugMode){
          print("offline_folder_tile error(id: ${widget.folderModel.id} , name: ${widget.folderModel.album}): $e");
        }
      }finally{
        setState(() {
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: albumArt
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color:albumArt != null ? Colors.transparent : Colors.accents.elementAt(widget.folderModel.id % Colors.accents.length).withOpacity(0.8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: (){
            //push to album screen
            PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: OfflineFolderView(folderModel: widget.folderModel,)
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(albumArt == null) ...[
                  const Icon(Icons.my_library_music_rounded,color: Colors.white,size: 40,),
                  const SizedBox(height: 10,),
                  Text(widget.folderModel.album  ?? "",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 2,),
                  const SizedBox(height: 10,),
                  Text(widget.folderModel.numOfSongs.toString(),style: const TextStyle(color: Colors.white70,fontWeight: FontWeight.w600,fontSize: 16),),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
