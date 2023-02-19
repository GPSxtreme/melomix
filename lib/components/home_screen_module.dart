import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:proto_music_player/components/online_song_tile.dart';
import 'package:proto_music_player/components/results_common_tile.dart';
import 'package:proto_music_player/components/top_album_tile.dart';
import 'package:proto_music_player/components/top_carousel_card.dart';
import 'package:proto_music_player/screens/app_router_screen.dart';
import 'package:proto_music_player/services/helper_functions.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreenModule extends StatefulWidget {
  const HomeScreenModule({Key? key, required this.languages}) : super(key: key);
  final List<String> languages;
  @override
  State<HomeScreenModule> createState() => _HomeScreenModuleState();
}

class _HomeScreenModuleState extends State<HomeScreenModule> {
  bool isLoaded = false;
  List<OnlineSongResultTile> trendingSongs = [];
  List<TopAlbumTile> trendingAlbums = [];
  List<TopCarouselCard> displayCards = [];
  List<CommonResultTile> charts = [];
  List<CommonResultTile> playlists = [];
  List<CommonResultTile> albums = [];
  //The total carousel effect cards.
  int totalCardsCount = 5;
  //shows the index of current showing card.
  int currentCardIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
  String formatLanguages(){
    String language = '';
    for(String l in widget.languages){
      language += "$l,";
    }
    return language;
  }
  fetchData()async{
    if(mounted){
      setState(() {
        isLoaded = false;
      });
      String languages = formatLanguages();
      Response response = await get(Uri.parse("${HelperFunctions.apiDomain}modules?language=$languages"));
      final data = jsonDecode(response.body) as Map<dynamic,dynamic>;
      if(data["status"] == "SUCCESS"){
        if(data["data"]["trending"]["songs"].isNotEmpty){
          for(Map rawSong in data["data"]["trending"]["songs"]){
            Map song = await HelperFunctions.getSongById(rawSong["id"]);
            trendingSongs.add(OnlineSongResultTile(player: mainAudioPlayer, song: song["data"][0]));
          }
          if(data["data"]["trending"]["albums"].isNotEmpty){
            int count = totalCardsCount;
            for(Map album in data["data"]["trending"]["albums"]){
              count--;
              if(count >= 0){
                displayCards.add(TopCarouselCard(data: album));
              }else{
                trendingAlbums.add(TopAlbumTile(data: album));
              }
            }
          }
        }
        if(data["data"]["charts"].isNotEmpty){
          for(Map chart in data["data"]["charts"]){
            charts.add(CommonResultTile(data: chart));
          }
        }
        if(data["data"]["playlists"].isNotEmpty){
          for(Map playlist in data["data"]["playlists"]){
            playlists.add(CommonResultTile(data: playlist));
          }
        }
        if(data["data"]["albums"].isNotEmpty){
          for(Map album in data["data"]["albums"]){
            albums.add(CommonResultTile(data: album));
          }
        }
      }
      setState(() {
        isLoaded = true;
      });
    }
  }
  Widget label(String name) =>  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
    child: Text(name,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.white),textAlign: TextAlign.start,),
  );
  @override
  Widget build(BuildContext context) {
    if(isLoaded){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(trendingAlbums.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.only(left: 15,right: 15,top: 0),
              padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 10),
              child: CarouselSlider(
                  items: displayCards,
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height*0.27,
                    viewportFraction: 1,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    pauseAutoPlayOnTouch: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentCardIndex = index;
                      });
                    },
                  ),
              ),
            )
          ],
          if(trendingSongs.isNotEmpty) ...[
            label("Top songs"),
            HelperFunctions.listViewRenderer(trendingSongs,verticalGap: 5),
          ],
          if(trendingAlbums.isNotEmpty) ...[
            label("Top albums"),
            HelperFunctions.gridViewRenderer(trendingAlbums,horizontalPadding: 20, verticalPadding: 8, crossAxisCount: 2, crossAxisSpacing: 15,mainAxisSpacing: 10),
          ],
          if(trendingAlbums.isNotEmpty) ...[
            label("Top charts"),
            HelperFunctions.gridViewRenderer(charts,horizontalPadding: 20, verticalPadding: 8, crossAxisCount: 3, crossAxisSpacing: 15,mainAxisSpacing: 10),
          ],

          if(albums.isNotEmpty) ...[
            label("Discover albums"),
            HelperFunctions.gridViewRenderer(albums,horizontalPadding: 20, verticalPadding: 8, crossAxisCount: 3, crossAxisSpacing: 15,mainAxisSpacing: 10),
          ],
          if(playlists.isNotEmpty) ...[
            label("Discover playlists"),
            HelperFunctions.gridViewRenderer(playlists,horizontalPadding: 20, verticalPadding: 8, crossAxisCount: 3, crossAxisSpacing: 15,mainAxisSpacing: 10),
          ],
          const SizedBox(height: 70,)
        ],
      );
    }else{
      return const Center(
        heightFactor: 7,
          child: SpinKitRipple(color: Colors.white,size: 80,)
      );
    }
  }
}
