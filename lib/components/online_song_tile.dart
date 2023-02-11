import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';
import 'package:proto_music_player/main.dart';
import 'package:proto_music_player/screens/app_router_screen.dart';
import 'package:proto_music_player/services/helper_functions.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum DropdownItem{
  queue,
  download
}


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
                      mainAudioPlayer.audioSource!.sequence[snapshot.data!].tag.extras["id"] == widget.song["id"]){
                    return const SpinKitWave(color: Colors.white70,size: 35,);
                  }
                  return const SizedBox();
                },
              );
          },
        ),
      ),
      trailing: PopupMenuButton(
          icon: const Icon(LineIcons.verticalEllipsis,color: Colors.white,) ,
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 2),
          position: PopupMenuPosition.under,
          onSelected: (value)async{
            if(value == DropdownItem.queue){
              //add to queue
              if(!addedToQueue){
                setState(() {
                  addedToQueue = true;
                });
                await HelperFunctions.addSongToQueue(widget.song, widget.player);
              }
              // remove from queue
              else{
                Fluttertoast.showToast(
                    msg: "Song already in Queue.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: HexColor("4f4f4f"),
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
            }else{
              // download song
              HelperFunctions.downloadHttpSong(
                  songData: widget.song
              );
              Fluttertoast.showToast(
                  msg: "Downloading..",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: HexColor("4f4f4f"),
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          },
          itemBuilder: (context) =>[
            PopupMenuItem(
              value: DropdownItem.queue,
              child: Text(addedToQueue ? "In queue" : "Queue" ),
            ),
            const PopupMenuItem(
                value: DropdownItem.download,
                child: Text("Download")
            ),
          ]
      ),
    );
  }
}