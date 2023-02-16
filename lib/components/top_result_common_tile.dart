import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:proto_music_player/screens/artist_view_screen.dart';
import 'package:proto_music_player/screens/common_view_screen.dart';


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
    MediaQueryData device = MediaQuery.of(context);
    return GestureDetector(
      onTap: (){
        if(widget.data["type"] != "artist"){
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: CommonViewScreen(id: widget.data["id"], type: widget.data["type"],),
            withNavBar: true, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        }else{
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: ArtistViewScreen(artistId: widget.data['id'],),
            withNavBar: true, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 5),
        child: Container(
          height: device.orientation == Orientation.portrait ? device.size.height*0.25 : device.size.height *0.4,
          width: device.size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            image: DecorationImage(
              image: NetworkImage(widget.data["image"][0]["link"]),
              fit: BoxFit.cover,
                opacity: 1
            )
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: BackdropFilter(
              filter:ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      elevation: 40,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(double.infinity),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 64,
                        backgroundImage: NetworkImage(widget.data["image"][2]["link"]),
                      ),
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
                              color: Colors.black54
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
