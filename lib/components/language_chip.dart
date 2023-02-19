import 'package:flutter/material.dart';
import 'package:proto_music_player/services/local_data_service.dart';

class LanguageChip extends StatefulWidget {
  const LanguageChip({Key? key, required this.language}) : super(key: key);
  final String language;
  @override
  State<LanguageChip> createState() => _LanguageChipState();
}

class _LanguageChipState extends State<LanguageChip> {
  bool isSelected = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //check whether the language is selected.
    isAdded();
  }
  isAdded()async{
    if(mounted){
      List langs = await LocalDataService.getLanguages();
      if(langs.contains(widget.language.toLowerCase().trim())){
        setState(() {
          isSelected = true;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
        label: Text(widget.language,style: const TextStyle(color: Colors.white),),
        selected: isSelected,
      backgroundColor: Colors.black54,
      selectedColor: Colors.blue[400],
      onSelected: (value){
          setState(() {
            isSelected = value;
          });
            if(value == true){
              //Add this language to language list;
              LocalDataService.addLanguage(widget.language.toLowerCase());
            }else{
              //Remove this language from language list;
              LocalDataService.removeLanguage(widget.language.toLowerCase());
            }
      },
    );
  }
}
