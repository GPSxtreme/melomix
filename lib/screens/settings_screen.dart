import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:proto_music_player/components/language_chip.dart';
import '../services/app_settings.dart';
import '../services/helper_functions.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static String id = "settings_screen";
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<DropdownMenuItem<SongQuality>> qualityEntries = [];
  final List<DropdownMenuItem<VolumeLevel>> volumeEntries = [];
  late SongQuality qualityWifi ;
  late SongQuality qualityMd;
  late VolumeLevel volumeLevel;
  late bool isDataSaver;
  late bool allowExplicit;
  bool isLoaded = false;
  fetchSettings()async{
    for(final quality in SongQuality.values){
      qualityEntries.add(DropdownMenuItem<SongQuality>(
        value: quality,
        child: Text(quality.name.replaceAll("_", " ").capitalize()),
      ));
    }
    for(final volume in VolumeLevel.values){
      volumeEntries.add(DropdownMenuItem<VolumeLevel>(
        value: volume,
        child: Text(volume.name.capitalize()),
      ));
    }
    qualityWifi = AppSettings.qualityObjWifi;
    qualityMd = AppSettings.qualityObjMd;
    isDataSaver = AppSettings.isDataSaver;
    allowExplicit = AppSettings.allowExplicit;
    volumeLevel = VolumeLevel.values.firstWhere((obj) => obj.name == AppSettings.volumeLevel);
  }
  Widget label(String name , {FontWeight? fontWeight , double? fontSize}) =>  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
    child: Text(name,style: TextStyle(fontSize:fontSize ?? 19,fontWeight: fontWeight ?? FontWeight.w600,color: Colors.white),textAlign: TextAlign.start,),
  );
  Widget dataSaverActive(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: HexColor("111111"),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 16),
        child: Text("Data saver",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSettings();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //body
          ListView(
            children: [
              const SizedBox(height: 50,),
              label("Settings",fontSize: 40),
              //languages selection.
              label("Music languages",),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Wrap(
                  spacing: 6.0,
                  runSpacing: -8,
                  children: const [
                    LanguageChip(language: "English"),
                    LanguageChip(language: "Hindi"),
                    LanguageChip(language: "Tamil"),
                    LanguageChip(language: "Telugu"),
                    LanguageChip(language: "Punjabi"),
                    LanguageChip(language: "Marathi"),
                    LanguageChip(language: "Gujarati"),
                    LanguageChip(language: "Bengali"),
                    LanguageChip(language: "Kannada"),
                    LanguageChip(language: "Bhojpuri"),
                    LanguageChip(language: "Urdu"),
                    LanguageChip(language: "Haryanvi"),
                    LanguageChip(language: "Rajasthani"),
                    LanguageChip(language: "Odia"),
                    LanguageChip(language: "Assamese"),
                  ],
                ),
              ),
              //data saver switch.
              label("Data saver",),
              ListTile(
                title: const Text("Audio quality",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),),
                subtitle:const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text("Sets your audio quality to low(equivalent to 48kbit/s).",style: TextStyle(color: Colors.white70,fontSize: 12,fontWeight: FontWeight.w500),),
                ) ,
                trailing: Switch(
                  value: isDataSaver,
                  inactiveTrackColor: HexColor("111111"),
                  activeColor: Colors.blue[400],
                  onChanged: (value)async{
                    await AppSettings.setDataSaver(value);
                    setState(() {
                      isDataSaver = value;
                    });
                  },
                ),
              ),
              //streaming quality.
              label("Streaming quality",),
              //Wifi streaming quality.
              ListTile(
                // leading: const Icon(Icons.wifi,color: Colors.white,size: 35,),
                title: const Text("Over Wi-Fi",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),),
                trailing:!isDataSaver ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: BoxDecoration(
                    color: HexColor("111111"),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<SongQuality>(
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    underline: const SizedBox(),
                    value: qualityWifi,
                    items: qualityEntries,
                    dropdownColor: HexColor("111111"),
                    borderRadius: BorderRadius.circular(10),
                    style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),
                    onChanged: (quality)async{
                      if(quality != null) {
                        await AppSettings.setSongQualityWifi(quality);
                        setState(() {
                          qualityWifi = quality;
                        });
                      }
                    },
                  ),
                ) : dataSaverActive()
              ),
              const SizedBox(height: 5,),
              //Cellular streaming quality.
              ListTile(
                  // leading: const Icon(Icons.network_cell_rounded,color: Colors.white,size: 35,),
                  title: const Text("Over cellular",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),),
                  subtitle:const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child:Text("Streaming higher quality over a cellular connection uses more data.",style: TextStyle(color: Colors.white70,fontSize: 12,fontWeight: FontWeight.w500),),
                  ) ,
                  trailing:!isDataSaver ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                      color: HexColor("111111"),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<SongQuality>(
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      underline: const SizedBox(),
                      value: qualityMd,
                      items: qualityEntries,
                      dropdownColor: HexColor("111111"),
                      borderRadius: BorderRadius.circular(10),
                      style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),
                      onChanged: (quality)async{
                        if(quality != null) {
                          await AppSettings.setSongQualityMd(quality);
                          setState(() {
                            qualityMd = quality;
                          });
                        }
                      },
                    ),
                  ) : dataSaverActive()
              ),
              label("Playback",),
              //Explicit content switch.
              ListTile(
                title: const Text("Allow explicit content",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),),
                subtitle:const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text("Turn on to play explicit content\nExplicit content is labeled with 'E' tag.",style: TextStyle(color: Colors.white70,fontSize: 12,fontWeight: FontWeight.w500),),
                ) ,
                trailing: Switch(
                  value: allowExplicit,
                  inactiveTrackColor: HexColor("111111"),
                  activeColor: Colors.blue[400],
                  onChanged: (value)async{
                    await AppSettings.setAllowExplicit(value);
                    setState(() {
                      allowExplicit = value;
                    });
                  },
                ),
              ),
              //Volume level setting.
              ListTile(
                title: const Text("Volume level",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),),
                subtitle:const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text("Adjust the volume for your environment.Loud may diminish aoudio quality.No effect on audio quality in Normal or Quiet.",style: TextStyle(color: Colors.white70,fontSize: 12,fontWeight: FontWeight.w500),),
                ) ,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: BoxDecoration(
                    color: HexColor("111111"),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<VolumeLevel>(
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    underline: const SizedBox(),
                    value: volumeLevel,
                    items: volumeEntries,
                    dropdownColor: HexColor("111111"),
                    borderRadius: BorderRadius.circular(10),
                    style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),
                    onChanged: (level)async{
                      if(level != null) {
                        await AppSettings.setVolumeLevel(level.name);
                        setState(() {
                          volumeLevel = level;
                        });
                      }
                    },
                  ),
                ),
              ),
              //Maker sign.
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: HelperFunctions.makerSign(),
              ),
            ],
          ),
          if(MediaQuery.of(context).orientation == Orientation.portrait)

          HelperFunctions.collapsedPlayer()
        ],
      ),
    );
  }
}
