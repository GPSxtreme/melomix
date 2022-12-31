import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:proto_music_player/components/songResultTile.dart';
import 'package:proto_music_player/services/helperFunctions.dart';
import '../components/playerButtons.dart';
import 'package:hexcolor/hexcolor.dart';

class ProtoHome extends StatefulWidget {
  static String id = "proto_home";
  static Map presentSong = {};
  static List<AudioSource> audioQueueItemsList = [];
  static ConcatenatingAudioSource audioQueue = ConcatenatingAudioSource(children: audioQueueItemsList,useLazyPreparation: true,shuffleOrder: DefaultShuffleOrder());
  const ProtoHome({Key? key}) : super(key: key);
  @override
  State<ProtoHome> createState() => _ProtoHomeState();
}

class _ProtoHomeState extends State<ProtoHome> {
  late AudioPlayer _audioPlayer;
  Map searchResults = {};
  List<SongResultTile> allResults = [];
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
  searchFunction(String query)async{
    if(allResults.length > 20){
      setState(() {
        allResults.clear();
      });
    }
    searchResults = await HelperFunctions.querySong(query.trim(), 10);
    if(searchResults["status"] == "SUCCESS" && searchResults["data"]["results"].isNotEmpty){
      for(Map song in searchResults["data"]["results"]){
        setState(() {
          allResults.add(SongResultTile(song: song,player: _audioPlayer,));
        });
      }
    }
  }
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Text(" "),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        elevation: 1,
        type : BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
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
            activeIcon: Icon(Icons.search,color: Colors.blue,),
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
      body: Center(
        child: Stack(
          children: [
            if(selectedIndex == 0) ...[

            ],
            if(selectedIndex == 2) ...[
              searchPage(),
            ],
            Positioned(
                bottom: 0,
                child: GestureDetector(
                  onPanUpdate:  (details) {
                    int sensitivity = 8;
                    if (details.delta.dy > sensitivity) {
                      // Down Swipe
                    } else if(details.delta.dy < -sensitivity && ProtoHome.presentSong.isNotEmpty){
                      // Up Swipe
                      showModalBottomSheet(
                          context: context,
                          elevation: 0,
                          barrierColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => showFullPlayer()
                      );
                    }
                  },
                  child: Container(
                    height: ProtoHome.presentSong.isNotEmpty ? 99:70,
                    padding: null,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18)),
                      color: HexColor("#212121").withOpacity(0.99),
                    ),
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(ProtoHome.presentSong.isNotEmpty)
                          SizedBox(
                            height: 30,
                            child: IconButton(onPressed: (){
                              if(ProtoHome.presentSong.isNotEmpty){
                                showModalBottomSheet(
                                    context: context,
                                    elevation: 0,
                                    barrierColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) => showFullPlayer()
                                );
                              }
                            },
                                icon: const Icon(Icons.arrow_drop_up,color: Colors.white,)),
                          ),
                          PlayerButtons(_audioPlayer)
                        ],
                      )
                  ),
                )
            )
          ],
        ),

      ),
    );
  }

  Widget searchPage() {
    return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                child: TextField(
                  textAlign: TextAlign.start,
                  cursorColor: Colors.black,
                  cursorHeight: 20,
                  keyboardType: TextInputType.name,
                  onSubmitted: (query){
                    searchFunction(query);
                  },
                  onChanged:(query){
                    searchFunction(query);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: 'What do you want to listen to?',
                    prefixIcon: const Icon(Icons.search,color: Colors.black,),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("111111"), width: 1)
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("111111"), width: 1)
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: HexColor("111111"), width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              queriesTileContainer(),
            ],
          );
  }
  Widget queriesTileContainer(){
    if(allResults.isNotEmpty){
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: allResults.length,
          itemBuilder: (context,index){
            return allResults[index];
          },
        ),
      );
    }else{
      return const Center(
        heightFactor: 15,
        child:Text("No results",style: TextStyle(fontSize: 16),),

      );
    }
  }

  Widget showFullPlayer() {
    String hasLyrics = ProtoHome.presentSong["hasLyrics"];
    return DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: 0.5,
      maxChildSize: 1,
      builder: (_,controller) => Container(
        color: HexColor("212121"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.85,
              height: MediaQuery.of(context).size.width*0.85,
              decoration:BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    ProtoHome.presentSong["image"][2]["link"],
                    scale: 1.6,
                  ),
                  fit: BoxFit.cover
                ),
                boxShadow: [
                  BoxShadow(
                    color: HexColor("#d5e0f2"),
                    offset: const Offset(
                      1.0,
                      -2.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 0.5,
                  ), //BoxShadow
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ), //BoxShadow
                ],
              ),
            ),
            const SizedBox(height: 25,),
            Text(ProtoHome.presentSong["name"],style: const TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,),
            const SizedBox(height: 10,),
            Text(ProtoHome.presentSong["primaryArtists"] ?? "",style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w400),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis),
            const SizedBox(height: 20,),
            if(hasLyrics == "true")
              SizedBox(
                width: 100,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue
                    ),
                      onPressed: (){
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => showLyrics()
                        );
                      },
                      child: Row(
                      children: const [
                        Icon(Icons.lyrics,color: Colors.white,),
                        SizedBox(width: 5,),
                        Text("Lyrics",style: TextStyle(color: Colors.white,))
                    ],
                  )),
                ),
              ),
            const SizedBox(height: 20,),
            Text(ProtoHome.presentSong["copyright"] ?? "",style: const TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w300),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis),
            const SizedBox(height: 20,),
            PlayerButtons(_audioPlayer),
          ],
        ),
      ),
    );
  }

  showLyrics() {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      builder:(_,controller) => Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: HexColor("#363636"),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28)
              )
          ),
          child: ListView(
            controller: controller,
            children: [
              Text(ProtoHome.presentSong["lyrics"],
                style: const TextStyle(
                  wordSpacing: 3.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                  height: 1.8,

                ),
                textAlign: TextAlign.center,

              ),
              const SizedBox(height: 20,),
              Text(ProtoHome.presentSong["lyricsCopyRight"].toString().replaceAll("<br>", '\n'),style: const TextStyle( wordSpacing: 1.2,color: Colors.blue,fontWeight: FontWeight.w600,fontSize: 15),textAlign: TextAlign.center,)
            ],
          )
      ),
    );
  }

}


