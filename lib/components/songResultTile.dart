import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:proto_music_player/services/helperFunctions.dart';

import '../screens/proto_home.dart';

class SongResultTile extends StatefulWidget {
  const SongResultTile({Key? key, required this.player, required this.song}) : super(key: key);
  final Map song;
  final AudioPlayer player;
  @override
  State<SongResultTile> createState() => _SongResultTileState();
}

class _SongResultTileState extends State<SongResultTile> {
  bool addedToQueue = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ()async{
        ProtoHome.presentSong = widget.song;
        HelperFunctions.playHttpSong(widget.song["downloadUrl"][3]["link"], widget.player);
        if(widget.song["hasLyrics"] == "true"){
          Map lyrics = await HelperFunctions.fetchLyrics(widget.song["id"]);
          if(lyrics["data"] != null){
            ProtoHome.presentSong["lyrics"] = lyrics["data"]["lyrics"];
            ProtoHome.presentSong["lyricsCopyRight"] = lyrics["data"]["copyright"];
          }
        }
      },
      title: Text(widget.song["name"],style: const TextStyle(color: Colors.black,fontSize: 17),),
      subtitle:Text(widget.song["primaryArtists"],style: const TextStyle(color: Colors.black,fontSize: 13),maxLines: 2,overflow: TextOverflow.ellipsis,),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.indigo,
        backgroundImage: NetworkImage(widget.song["image"][1]["link"]),
      ),
      trailing: IconButton(icon: !addedToQueue ?  const Icon(Icons.add): const Icon(Icons.check) , onPressed: () {
        if(!addedToQueue){
          setState(() {
            addedToQueue = true;
          });
          HelperFunctions.addSongToQueue(widget.song["downloadUrl"][3]["link"], widget.player);
          HelperFunctions.showSnackBar(context, "Added ${widget.song["name"]} to Queue", 1800,bgColor: Colors.indigo);
        }
        },
      ),
    );
  }
}
