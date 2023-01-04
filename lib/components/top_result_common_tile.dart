import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:proto_music_player/screens/playlist_view_screen.dart';


class TopCommonResultTile extends StatefulWidget {
  const TopCommonResultTile({Key? key, required this.data}) : super(key: key);
  final Map data;
  @override
  State<TopCommonResultTile> createState() => _TopCommonResultTileState();
}

class _TopCommonResultTileState extends State<TopCommonResultTile> {
  HtmlUnescape htmlDecode = HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.data["type"] != "artist"){
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: PlaylistViewScreen(id: widget.data["id"], type: widget.data["type"],),
            withNavBar: true, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 5),
        child: Container(
          height: MediaQuery.of(context).size.height*0.25,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
            image: DecorationImage(
              image: NetworkImage(widget.data["image"][2]["link"]),
              fit: BoxFit.cover,
                opacity: 1
            )
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter:ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 63,
                      backgroundImage: NetworkImage(widget.data["image"][2]["link"]),
                    ),
                    const SizedBox(width: 5,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            htmlDecode.convert(widget.data["title"]),
                            maxLines: 2,
                            style: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                            overflow:TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 15,),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: HexColor("111111").withOpacity(0.8)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                              child: Text(widget.data["type"].toString().toUpperCase(),style: const TextStyle(color: Colors.white70),),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
