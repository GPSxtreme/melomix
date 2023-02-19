import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../screens/common_view_screen.dart';

class TopCarouselCard extends StatefulWidget {
  const TopCarouselCard({Key? key, required this.data}) : super(key: key);
  final Map data;
  @override
  State<TopCarouselCard> createState() => _TopCarouselCardState();
}

class _TopCarouselCardState extends State<TopCarouselCard> {
  HtmlUnescape htmlDecode = HtmlUnescape();
  double borderRadius = 8.0;
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
  String artists() {
    String artists = "";
    if(widget.data["artists"].isNotEmpty){
      for (int i = 0; i < widget.data["artists"].length; i++) {
        if (i != widget.data["artists"].length - 1) {
          artists += "${htmlDecode.convert(widget.data["artists"][i]["name"].trim())},";
        } else {
          artists += "${widget.data["artists"][i]["name"]}";
        }
      }
    }
    return artists;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HexColor("222222"),
          borderRadius: BorderRadius.circular(borderRadius),
          image: DecorationImage(
              image: NetworkImage(widget.data["image"][2]["link"]),
            fit: BoxFit.cover
          )
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
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
                  filter : ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(borderRadius) , bottomRight: Radius.circular(borderRadius)),
                      ),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(htmlDecode.convert(widget.data["name"]),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 22),maxLines: 2,textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
                            const SizedBox(height: 4,),
                            Text(artists(),style: const TextStyle(color: Colors.white70,fontWeight: FontWeight.w500,fontSize: 14),textAlign: TextAlign.start,maxLines: 2,overflow: TextOverflow.ellipsis,),
                          ],
                        ),
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
