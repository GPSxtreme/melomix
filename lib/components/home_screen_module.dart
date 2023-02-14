import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:proto_music_player/components/online_song_tile.dart';
import 'package:proto_music_player/components/results_common_tile.dart';
import 'package:proto_music_player/screens/app_router_screen.dart';
import 'package:proto_music_player/services/helper_functions.dart';

class HomeScreenModule extends StatefulWidget {
  const HomeScreenModule({Key? key, required this.languages}) : super(key: key);
  final List<String> languages;
  @override
  State<HomeScreenModule> createState() => _HomeScreenModuleState();
}

class _HomeScreenModuleState extends State<HomeScreenModule> {
  bool isLoaded = false;
  List<OnlineSongResultTile> trendingSongs = [];
  List<CommonResultTile> trendingAlbums = [];
  List<CommonResultTile> charts = [];
  List<CommonResultTile> playlists = [];
  List<CommonResultTile> albums = [];
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
            for(Map album in data["data"]["trending"]["albums"]){
              trendingAlbums.add(CommonResultTile(data: album));
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
    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 18),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:  [
            Text(name,style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white),textAlign: TextAlign.start,),
          ],
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    if(isLoaded){
      return Column(
        children: [
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
