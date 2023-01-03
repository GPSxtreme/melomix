import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:proto_music_player/services/helper_functions.dart';
import 'package:html_unescape/html_unescape.dart';

class SongResultTile extends StatefulWidget {
  const SongResultTile({Key? key, required this.player, required this.song}) : super(key: key);
  final Map song;
  final AudioPlayer player;
  @override
  State<SongResultTile> createState() => _SongResultTileState();
}

class _SongResultTileState extends State<SongResultTile> {
  bool addedToQueue = false;
  HtmlUnescape htmlDecode = HtmlUnescape();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addedToQueue = HelperFunctions.checkIfAddedInQueue(widget.song["id"]);
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ()async{
        await HelperFunctions.playHttpSong(widget.song, widget.player);
      },
      title: Text(htmlDecode.convert(widget.song["name"]),style: const TextStyle(color: Colors.white,fontSize: 17),maxLines: 2,overflow: TextOverflow.ellipsis,),
      subtitle:Text(htmlDecode.convert(widget.song["primaryArtists"]),style: const TextStyle(color: Colors.white,fontSize: 13),maxLines: 2,overflow: TextOverflow.ellipsis,),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.indigo,
        backgroundImage: NetworkImage(widget.song["image"][1]["link"]),
      ),
      trailing: IconButton(icon: !addedToQueue ?  const Icon(Icons.add_to_queue,color: Colors.white,): const Icon(Icons.check,color: Colors.white,) ,
        onPressed: () async{
          if(!addedToQueue){
            setState(() {
              addedToQueue = true;
            });
            await HelperFunctions.addSongToQueue(widget.song, widget.player);
          }else{
            setState(() {
              addedToQueue = false;
            });
            await HelperFunctions.removeFromQueue(widget.song);
          }
        },
      ),
    );
  }
}
