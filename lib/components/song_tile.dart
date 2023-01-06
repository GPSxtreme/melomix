import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';
import 'package:proto_music_player/services/helper_functions.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:line_icons/line_icons.dart';

class OnlineSongResultTile extends StatefulWidget {
  const OnlineSongResultTile({Key? key, required this.player, required this.song}) : super(key: key);
  final Map song;
  final AudioPlayer player;
  @override
  State<OnlineSongResultTile> createState() => _OnlineSongResultTileState();
}

class _OnlineSongResultTileState extends State<OnlineSongResultTile> {
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
      title: Text(htmlDecode.convert(widget.song["name"]),style: const TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),maxLines: 2,overflow: TextOverflow.ellipsis,),
      subtitle:Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            //if has explicit content
            if(widget.song["explicitContent"] == 1) ...[
              Container(
                decoration: BoxDecoration(
                    color: HexColor("4f4f4f"),
                    borderRadius: BorderRadius.circular(3)
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                  child: Text('E',style: TextStyle(color: Colors.white70),),
                ),
              ),
              const SizedBox(width: 5,),
            ],
            Flexible(child: Text(htmlDecode.convert(widget.song["primaryArtists"]),style: const TextStyle(color: Colors.white70,fontSize: 13),maxLines: 2,overflow: TextOverflow.ellipsis,)),
          ],
        ),
      ),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.indigo,
        backgroundImage: NetworkImage(widget.song["image"][1]["link"]),
      ),
      trailing: IconButton(icon: !addedToQueue ?  const Icon(LineIcons.verticalEllipsis,color: Colors.white,): const Icon(Icons.check,color: Colors.white,) ,
        onPressed: () async{
          if(!addedToQueue){
            setState(() {
              addedToQueue = true;
            });
            await HelperFunctions.addSongToQueue(widget.song, widget.player);
          }else{
            await HelperFunctions.removeFromQueue(widget.song);
            setState(() {
              addedToQueue = false;
            });
          }
        },
      ),
    );
  }
}
