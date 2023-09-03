import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
<<<<<<< Updated upstream
<<<<<<< Updated upstream

import '../components/home_screen_module.dart';
import '../services/helper_functions.dart';
=======
import '../components/online_song_tile.dart';
=======
import 'package:proto_music_player/models/song_details_by_id.dart';
import '../models/home_page_data.dart';
>>>>>>> Stashed changes
import '../services/helper_functions.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'app_router_screen.dart';
import 'package:http/http.dart';
import 'package:proto_music_player/components/results_common_tile.dart';
import 'package:proto_music_player/components/top_album_tile.dart';
import 'package:proto_music_player/components/top_carousel_card.dart';
import 'package:proto_music_player/services/local_data_service.dart';

>>>>>>> Stashed changes

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String id = "home_screen";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  fetchData()async{
    if(mounted){
      setState(() {
        isLoaded = false;
      });
      trendingSongs.clear();
      trendingAlbums.clear();
      displayCards.clear();
      charts.clear();
      playlists.clear();
      albums.clear();
      String? languages = await LocalDataService.getLanguagesString();
      if(languages == null){
        await LocalDataService.addLanguage("english");
      }
<<<<<<< Updated upstream
      Response response = await get(Uri.parse("${HelperFunctions.apiDomain}modules?language=${languages ?? "english"}"));
      final data = jsonDecode(response.body) as Map<dynamic,dynamic>;
      if(data["status"] == "SUCCESS"){
        if(data["data"]["trending"]["songs"].isNotEmpty){
          for(Map rawSong in data["data"]["trending"]["songs"]){
            Map song = await HelperFunctions.getSongById(rawSong["id"]);
            trendingSongs.add(OnlineSongResultTile(player: mainAudioPlayer, song: song["data"][0]));
=======
      Response response = await get(Uri.parse("${HelperFunctions.apiDomain}modules?language=$languages"));
      final homePageData = homePageDataFromJson(response.body);
      if(homePageData.status == "SUCCESS"){
        if(homePageData.data.trending.songs.isNotEmpty){
          for(Song rawSong in homePageData.data.trending.songs){
            SongDetailsById? song = await HelperFunctions.getSongById(rawSong.id);
            if(song != null) {
              trendingSongs.add(OnlineSongResultTile(player: mainAudioPlayer, song: song!.data.first));
            }
>>>>>>> Stashed changes
          }
          if(homePageData.data.trending.albums.isNotEmpty){
            int count = totalCardsCount;
            for(TrendingAlbum album in homePageData.data.trending.albums){
              count--;
              if(count >= 0){
                displayCards.add(TopCarouselCard(data: album.toJson()));
              }else{
                trendingAlbums.add(TopAlbumTile(data: album.toJson()));
              }
            }
          }
        }
        if(homePageData.data.charts.isNotEmpty){
          for(Chart chart in homePageData.data.charts){
            charts.add(CommonResultTile(data: chart.toJson()));
          }
        }
        if(homePageData.data.playlists.isNotEmpty){
          for(Playlist playlist in homePageData.data.playlists){
            playlists.add(CommonResultTile(data: playlist.toJson()));
          }
        }
        if(homePageData.data.albums.isNotEmpty){
          for(DataAlbum dataAlbum in homePageData.data.albums){
            albums.add(CommonResultTile(data: dataAlbum.toJson()));
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
  Future<void> onRefresh()async{
    await fetchData();
  }
  Widget contents(){
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
<<<<<<< Updated upstream
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 13),
                child: Row(
                  children: [
                    Text("Melomix",style: GoogleFonts.pacifico(fontSize: 27,color: Colors.white,),textAlign: TextAlign.start,),
                    const Spacer(),
                    const CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person_rounded,color: Colors.blue,size: 30,),
                    )
                  ],
                ),
              ),
              const HomeScreenModule(languages: ["english"],),
            ],
          ),
          //body
          HelperFunctions.collapsedPlayer()
        ],
=======
      body: RefreshIndicator(
        onRefresh: onRefresh,
        color: Colors.black,
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 13),
                  child: Hero( tag:'logo',child: Text("Melomix",style: GoogleFonts.pacifico(fontSize: 27,color: Colors.white,),textAlign: TextAlign.start,)),
                ),
                contents()
              ],
            ),
            //body
            HelperFunctions.collapsedPlayer()
          ],
        ),
>>>>>>> Stashed changes
      ),
    );
  }
}
