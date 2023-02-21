// ignore_for_file: constant_identifier_names

import 'package:proto_music_player/services/local_data_service.dart';
import '../screens/app_router_screen.dart';

enum SongQuality{
  very_low,
  low,
  medium,
  high,
  very_high
}
enum VolumeLevel{
  quiet,
  normal,
  loud,
}
const String DATA_SAVER = "48kbps";
class AppSettings{
  static late SongQuality qualityObjWifi;
  static late SongQuality qualityObjMd;
  static late String qualityWifi;
  static late String qualityMd;
  static late bool isDataSaver;
  static late bool allowExplicit;
  static late String volumeLevel;
  static Map<String , SongQuality> qualityMap = {
  "12kbps" : SongQuality.very_low,
  "48kbps" : SongQuality.low,
  "96kbps" : SongQuality.medium,
  "160kbps" : SongQuality.high,
  "320kbps" : SongQuality.very_high,
  };
  static Future<void> fetchAppSettings()async{
    String? wifi = await LocalDataService.getSongQualityWifi();
    String? md = await LocalDataService.getSongQualityMd();
    qualityObjWifi = qualityMap[wifi ?? ""] ?? SongQuality.high;
    qualityWifi = wifi ?? "160kbps";
    qualityObjMd = qualityMap[md ?? ""] ?? SongQuality.medium;
    qualityMd = md ?? "96kbps";
    isDataSaver = await LocalDataService.getIsDataSaver();
    allowExplicit = await LocalDataService.getAllowExplicit();
    volumeLevel = await LocalDataService.getVolumeLevel();
  }
  static Future<void> setSongQualityWifi(SongQuality quality) async{
    qualityObjWifi = quality;
    for(String key in qualityMap.keys){
      if(qualityMap[key] == quality){
        AppSettings.qualityWifi = key;
      }
    }
    await LocalDataService.setSongQualityWifi(AppSettings.qualityWifi);
  }
  static Future<void> setVolumeLevel(String level)async{
    volumeLevel = level;
    if(level == VolumeLevel.loud.name){
      //increase by 70%
      mainAudioPlayer.setVolume(1.7);
    }else if(level == VolumeLevel.quiet.name){
      //decrease by 70%
      mainAudioPlayer.setVolume(0.3);
    }else {
      //set back to normal
      mainAudioPlayer.setVolume(1.0);
    }
    await LocalDataService.setVolumeLevel(level);
  }
  static Future<void> setDataSaver(bool val)async{
    isDataSaver = val;
    await LocalDataService.setDataSaver(val);
  }
  static Future<void> setAllowExplicit(bool val)async{
    allowExplicit = val;
    await LocalDataService.setAllowExplicit(val);
  }
  static Future<void> setSongQualityMd(SongQuality quality) async{
    qualityObjMd = quality;
    for(String key in qualityMap.keys){
      if(qualityMap[key] == quality){
        AppSettings.qualityMd = key;
      }
    }
    await LocalDataService.setSongQualityMd(AppSettings.qualityMd);
  }
  static String getSongQuality(){
    if(!isDataSaver){
      if(AppRouter.isOverWifi) {
        //return wifi streaming quality
        return qualityWifi;
      } else {
        //return cellular streaming quality
        return qualityMd;
      }
    }else{
      //return data saver quality
      return DATA_SAVER;
    }
  }
}