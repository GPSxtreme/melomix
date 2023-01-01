import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../components/songResultTile.dart';
import '../services/helperFunctions.dart';
import '../components/playerButtons.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeScreen extends StatefulWidget {
  static String id = "proto_home";
  static ConcatenatingAudioSource queue = ConcatenatingAudioSource(children: [],useLazyPreparation: true);
  static List audioQueueSongData = [];
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AudioPlayer _audioPlayer;
  Map searchResults = {};
  List<SongResultTile> allResults = [];
  int selectedIndex = 0;
  HelperFunctions helperFunctions = HelperFunctions();
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }
  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
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
      // appBar: AppBar(
      //   title: const Text(" "),
      //   backgroundColor: Colors.black87,
      //   elevation: 0,
      // ),
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
                    } else if(details.delta.dy < -sensitivity && HomeScreen.audioQueueSongData.isNotEmpty){
                      // Up Swipe
                      showModalBottomSheet(
                          context: context,
                          elevation: 0,
                          barrierColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => showFullPlayer(context)
                      );
                    }
                  },
                  child: Container(
                    height: HomeScreen.audioQueueSongData.isNotEmpty ? 99:70,
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
                          if(HomeScreen.audioQueueSongData.isNotEmpty)
                          SizedBox(
                            height: 30,
                            child: IconButton(onPressed: (){
                              if(HomeScreen.audioQueueSongData.isNotEmpty){
                                showModalBottomSheet(
                                    context: context,
                                    elevation: 0,
                                    barrierColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) => showFullPlayer(context)
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
  //search page
  Widget searchPage() {
    return Column(
            children: [
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                child: TextField(
                  textAlign: TextAlign.start,
                  cursorColor: Colors.black,
                  cursorHeight: 20,
                  keyboardType: TextInputType.name,
                  onSubmitted: (query){
                    FocusManager.instance.primaryFocus?.unfocus();
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
              queriesTileContainer(),
            ],
          );
  }
  //search page queries
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
  //Draggable Full screen player
  Widget showFullPlayer(BuildContext context) {
    return StreamBuilder(
      stream: _audioPlayer.currentIndexStream,
      builder:(context,snapshot){
        if(snapshot.data != null){
          String hasLyrics = HomeScreen.audioQueueSongData[snapshot.data!]["hasLyrics"];
          return GestureDetector(
            onPanUpdate: (details){
              int sensitivity = 17;
              // print(details.delta.dx);
              if(details.delta.dx > sensitivity){
                if(_audioPlayer.hasPrevious){
                  _audioPlayer.seekToPrevious();
                }
              } else if (details.delta.dx < -sensitivity){
                if(_audioPlayer.hasNext){
                  _audioPlayer.seekToNext();
                }
              }
            },
            child: DraggableScrollableSheet(
              initialChildSize: 1,
              minChildSize: 0.5,
              maxChildSize: 1,
              builder: (_,controller) => Container(
                color: HexColor("212121"),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.85,
                        height: MediaQuery.of(context).size.width*0.85,
                        decoration:BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                HomeScreen.audioQueueSongData[snapshot.data!]["image"][2]["link"],
                                scale: 1.6,
                              ),
                              fit: BoxFit.cover
                          ),
                        ),
                      ),
                      const SizedBox(height: 25,),
                      Text(HomeScreen.audioQueueSongData[snapshot.data!]["name"],style: const TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 10,),
                      Text(HomeScreen.audioQueueSongData[snapshot.data!]["primaryArtists"] ?? "",style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w400),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis),
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
                                      builder: (context) => showLyrics(snapshot.data!)
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
                      Text(HomeScreen.audioQueueSongData[snapshot.data!]["copyright"] ?? "",style: const TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w300),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8),
                        child: Row(
                          children: [
                            StreamBuilder(
                              stream: _audioPlayer.createPositionStream(),
                              builder: (context,snapshot){
                                if(snapshot.data != null){
                                  return Text(HelperFunctions.printDuration(snapshot.data!), style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),textAlign: TextAlign.start,);
                                } else {
                                  return const Text("");
                                }
                              },
                            ),
                            const Spacer(),
                            if(_audioPlayer.duration != null)
                              Text(HelperFunctions.printDuration(_audioPlayer.duration!), style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),textAlign: TextAlign.start,)
                          ],
                        ),
                      ),
                      PlayerButtons(_audioPlayer),
                    ],
                  ),
                ),
              ),
            ),
          );
        }else{
          return const SizedBox(height: 0,);
        }
      }
    );
  }
  //Draggable lyrics sheet
  showLyrics(int index) {
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
              Text(HomeScreen.audioQueueSongData[index]["lyrics"],
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
              Text(HomeScreen.audioQueueSongData[index]["lyricsCopyRight"].toString().replaceAll("<br>", '\n'),style: const TextStyle( wordSpacing: 1.2,color: Colors.blue,fontWeight: FontWeight.w600,fontSize: 15),textAlign: TextAlign.center,)
            ],
          )
      ),
    );
  }
}


