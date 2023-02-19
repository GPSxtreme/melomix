import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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
  late SongQuality qualityWifi ;
  late SongQuality qualityMd;
  bool isLoaded = false;
  fetchSettings()async{
    for(final quality in SongQuality.values){
      qualityEntries.add(DropdownMenuItem<SongQuality>(
        value: quality,
        child: Text(quality.name),
      ));
    }
    qualityWifi = AppSettings.qualityObjWifi;
    qualityMd = AppSettings.qualityObjMd;
  }
  Widget label(String name , {FontWeight? fontWeight , double? fontSize}) =>  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
    child: Text(name,style: TextStyle(fontSize:fontSize ?? 20,fontWeight: fontWeight ?? FontWeight.w700,color: Colors.white),textAlign: TextAlign.start,),
  );
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
              //song quality
              label("Streaming quality",fontWeight: FontWeight.w400 , fontSize: 18),
              ListTile(
                leading: const Icon(Icons.wifi,color: Colors.white,size: 35,),
                title: const Text("Over Wi-Fi",style: TextStyle(color: Colors.white,fontSize: 18),),
                trailing: Container(
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
                )
              ),
              const SizedBox(height: 5,),
              ListTile(
                  leading: const Icon(Icons.network_cell_rounded,color: Colors.white,size: 35,),
                  title: const Text("Over mobile data",style: TextStyle(color: Colors.white,fontSize: 18),),
                  subtitle:const Text("recommended medium",style: TextStyle(color: Colors.white70,fontSize: 13),) ,
                  trailing: Container(
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
                  )
              ),
            ],
          ),
          Positioned(
            bottom: 70,
            right: 0,
            left: 0,
            child: HelperFunctions.makerSign(),
          ),
          HelperFunctions.collapsedPlayer()
        ],
      ),
    );
  }
}
