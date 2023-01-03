import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:just_audio/just_audio.dart';
import 'package:proto_music_player/screens/search_page_screen.dart';
import '../components/player_buttons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'full_player_screen.dart';

class HomeScreen extends StatefulWidget {
  static String id = "proto_home";
  static ConcatenatingAudioSource queue = ConcatenatingAudioSource(children: [],useLazyPreparation: true);
  static List audioQueueSongData = [];
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AudioPlayer audioPlayer;
  int selectedIndex = 0;
  HtmlUnescape htmlDecode = HtmlUnescape();
  // List<Widget> pageList = [
  //   SearchPage(player: audioPlayer),
  //
  // ]
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }
  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset : false,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        elevation: 1,
        type : BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Colors.white,),
            activeIcon: Icon(Icons.home,color: Colors.blue,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_music ,color: Colors.white,),
            activeIcon: Icon(Icons.my_library_music ,color: Colors.blue,),
            label: 'My music',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,color: Colors.white,),
            activeIcon: Icon(Icons.search_rounded,color: Colors.blue,),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,color: Colors.white,),
            activeIcon: Icon(Icons.settings,color: Colors.blue,),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_sharp,color: Colors.white,),
            activeIcon: Icon(Icons.download_sharp,color: Colors.blue,),
            label: 'Downloads',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: onItemTapped
      ),
      body: Stack(
        children: [
          if(selectedIndex == 0) ...[
          //home page
          ],
          if(selectedIndex == 2)
            SearchPage(player: audioPlayer,),
          Positioned(
              bottom: 0,
              child: StreamBuilder(
                stream: audioPlayer.currentIndexStream,
                builder:(context,snapshot){
                  if(snapshot.data != null && HomeScreen.queue.length != 0){
                    return GestureDetector(
                      onPanUpdate:  (details) {
                        int sensitivity = 8;
                        if (details.delta.dy > sensitivity) {
                          // Down Swipe
                        } else if(details.delta.dy < -sensitivity && HomeScreen.audioQueueSongData.isNotEmpty){
                          // Up Swipe
                          showModalBottomSheet(
                              context: context,
                              elevation: 0,
                              barrierColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (context) => ShowFullPlayer(player: audioPlayer,)
                          );
                        }
                      },
                      child : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18)),
                            color: HexColor("111111").withOpacity(1),
                          ),
                          child:Row(
                            children: [
                              GestureDetector(
                                onTap:(){
                                  showModalBottomSheet(
                                      context: context,
                                      elevation: 0,
                                      barrierColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (context) => ShowFullPlayer(player: audioPlayer,)
                                  );
                                },
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(HomeScreen.audioQueueSongData[snapshot.data!]["image"][1]["link"],height: 55,width: 55,),
                                    ),
                                    const SizedBox(width: 15,),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width*0.35: MediaQuery.of(context).size.width*0.6
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(htmlDecode.convert(HomeScreen.audioQueueSongData[snapshot.data!]["name"]),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 1,),
                                          const SizedBox(height: 5,),
                                          Text(htmlDecode.convert(HomeScreen.audioQueueSongData[snapshot.data!]["primaryArtists"]),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 11),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 2,)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              PlayerController(audioPlayer, isFullScreen: false,nextBtnSize: 20,playPauseBtnSize: 30,prevBtnSize: 20,repeatBtnSize: 20,shuffleBtnSize: 20,),
                              if(!audioPlayer.hasNext)
                                const Spacer()
                            ],
                          )
                      )
                    );
                  } else {
                    return const SizedBox(height: 0,);
                  }
                },
              ),
          )
        ],
      ),
    );
  }
}


