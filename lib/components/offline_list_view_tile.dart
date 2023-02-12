import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:proto_music_player/screens/offline_folder_view.dart';


class OfflineListViewTile extends StatefulWidget {
  const OfflineListViewTile({Key? key, required this.folderModel}) : super(key: key);
  final AlbumModel folderModel;
  @override
  State<OfflineListViewTile> createState() => _OfflineListViewTileState();
}

class _OfflineListViewTileState extends State<OfflineListViewTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        //push to album screen
        PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: OfflineFolderView(folderModel: widget.folderModel,)
        );
      },
      leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.accents.elementAt(widget.folderModel.id % Colors.accents.length).withOpacity(0.8),
          child: const Icon(Icons.folder,size: 30,color: Colors.white,)
      ),
      title: Text(widget.folderModel.album,style: const TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),maxLines: 2,overflow: TextOverflow.ellipsis,),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(widget.folderModel.numOfSongs.toString(),style: const TextStyle(color: Colors.white70,fontSize: 17,fontWeight: FontWeight.w500)),
      ),
    );
  }
}
