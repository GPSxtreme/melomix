import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../screens/common_view_screen.dart';

class TopAlbumTile extends StatefulWidget {
  const TopAlbumTile({Key? key, required this.data}) : super(key: key);
  final Map data;
  @override
  State<TopAlbumTile> createState() => _TopAlbumTileState();
}

class _TopAlbumTileState extends State<TopAlbumTile> {
  double borderRadius = 8.0;
  HtmlUnescape htmlDecode = HtmlUnescape();
  pushViewScreen(){
    if(widget.data["type"] != "artist"){
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: CommonViewScreen(id: widget.data["id"], type: widget.data["type"],),
        withNavBar: true, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(widget.data["image"][2]["link"]),
          ),
        borderRadius: BorderRadius.circular(borderRadius)
      ),
      child: Material(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: (){
            pushViewScreen();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(borderRadius) , bottomRight: Radius.circular(borderRadius)),
                child: BackdropFilter(
                  filter : ImageFilter.blur(sigmaX: 15, sigmaY: 5),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(borderRadius) , bottomRight: Radius.circular(borderRadius)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(htmlDecode.convert(widget.data["name"]),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 15),maxLines: 2,textAlign: TextAlign.start,),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
