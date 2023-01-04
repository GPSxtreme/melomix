import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../screens/playlist_view_screen.dart';

class CommonResultTile extends StatefulWidget {
  const CommonResultTile({Key? key, required this.data}) : super(key: key);
  final Map data;
  @override
  State<CommonResultTile> createState() => _CommonResultTileState();
}

class _CommonResultTileState extends State<CommonResultTile> {
  pushViewScreen(){
    if(widget.data["type"] != "artist"){
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: PlaylistViewScreen(id: widget.data["id"], type: widget.data["type"],),
        withNavBar: true, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    if(widget.data["type"] == "artist"){
      return GestureDetector(
        onTap: (){
          pushViewScreen();
        },
        child: CircleAvatar(
          radius: 70,
          backgroundImage: NetworkImage(widget.data["image"][2]["link"]),
          backgroundColor: Colors.white,
        ),
      );
    }else{
      return GestureDetector(
        onTap: (){
          pushViewScreen();
        },
        child: Image.network(widget.data["image"][2]["link"],height: 150,width: 150,),
      );
    }
  }
}
