import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:proto_music_player/screens/app_router_screen.dart';

import '../services/helper_functions.dart';

class TrendingSongTile extends StatefulWidget {
  const TrendingSongTile({Key? key, required this.songData}) : super(key: key);
  final Map songData;
  @override
  State<TrendingSongTile> createState() => _TrendingSongTileState();
}

class _TrendingSongTileState extends State<TrendingSongTile> {
  HtmlUnescape htmlDecode = HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ()async{
        await HelperFunctions.playHttpSong(widget.songData, mainAudioPlayer);
      },
      title: Text(htmlDecode.convert(widget.songData["name"]),style: const TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),maxLines: 2,overflow: TextOverflow.ellipsis,),
      subtitle:Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            //if has explicit content
            if(widget.songData["explicitContent"] == 1) ...[
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
            Flexible(child: Text(htmlDecode.convert(widget.songData["primaryArtists"]),style: const TextStyle(color: Colors.white70,fontSize: 13),maxLines: 2,overflow: TextOverflow.ellipsis,)),
          ],
        ),
      ),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.indigo,
        backgroundImage: NetworkImage(widget.songData["image"][1]["link"]),
        child: StreamBuilder(
          stream: mainAudioPlayer.currentIndexStream,
          builder: (buildContext, AsyncSnapshot<int?> snapshot){
            return StreamBuilder(
              stream: mainAudioPlayer.playingStream,
              builder: (buildContext,AsyncSnapshot<bool> state){
                final isPlaying = state.data;
                if(isPlaying != null &&
                    isPlaying
                    && snapshot.hasData &&
                    mainAudioPlayer.audioSource!.sequence[snapshot.data!].tag.extras["id"] == widget.songData["id"]){
                  return const SpinKitWave(color: Colors.white70,size: 35,);
                }
                return const SizedBox();
              },
            );
          },
        ),
      ),
      trailing: const Icon(Icons.show_chart,color: Colors.white,size: 30,),
    );
  }
}
