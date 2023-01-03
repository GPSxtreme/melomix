import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';
import '../components/songResultTile.dart';
import '../services/helperFunctions.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.player}) : super(key: key);
  final AudioPlayer player;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map searchResults = {};
  List<SongResultTile> allResults = [];

  searchFunction(String query)async{
    // if(allResults.length > 10){
      setState(() {
        allResults.clear();
      });
    // }
    searchResults = await HelperFunctions.querySong(query.trim(), 15);
    if(searchResults["status"] == "SUCCESS" && searchResults["data"]["results"].isNotEmpty){
      for(Map song in searchResults["data"]["results"]){
        setState(() {
          allResults.add(SongResultTile(song: song,player: widget.player,));
        });
      }
    }
  }
  Widget searchPageContent(){
    if(allResults.isNotEmpty){
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: allResults.length,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: allResults[index],
            );
          },
        ),
      );
    }else{
      return const Center(
        heightFactor: 15,
        child:Text("No results",style: TextStyle(fontSize: 16,color: Colors.white),),

      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          child: TextField(
            textAlign: TextAlign.start,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            cursorHeight: 20,
            keyboardType: TextInputType.name,
            onSubmitted: (query){
              FocusManager.instance.primaryFocus?.unfocus();
              searchFunction(query);
            },
            // onChanged:(query){
            //   searchFunction(query);
            // },
            decoration: InputDecoration(
              filled: true,
              fillColor: HexColor("111111"),
              hintText: 'What do you want to listen to?',
              hintStyle: const TextStyle(color: Colors.white24),
              prefixIcon: const Icon(Icons.search,color: Colors.white,),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor("111111"), width: 3),
                  borderRadius: BorderRadius.circular(100)
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor("111111"), width: 3),
                  borderRadius: BorderRadius.circular(100)
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor("111111"), width: 3),
                  borderRadius: BorderRadius.circular(100)
              ),
            ),
          ),
        ),
        searchPageContent(),
      ],
    );
  }

}
