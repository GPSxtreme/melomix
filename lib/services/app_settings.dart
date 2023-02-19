import 'package:proto_music_player/services/local_data_service.dart';

enum SongQuality{
  veryLow,
  low,
  medium,
  high,
  veryHigh
}
class AppSettings{
  static late SongQuality qualityObjWifi;
  static late SongQuality qualityObjMd;
  static late String qualityWifi;
  static late String qualityMd;
  static Map<String , SongQuality> qualityMap = {
  "12kbps" : SongQuality.veryLow,
  "48kbps" : SongQuality.low,
  "96kbps" : SongQuality.medium,
  "160kbps" : SongQuality.high,
  "320kbps" : SongQuality.veryHigh,
  };
  static Future<void> fetchAppSettings()async{
    String? wifi = await LocalDataService.getSongQualityWifi();
    String? md = await LocalDataService.getSongQualityMd();
    qualityObjWifi = qualityMap[wifi ?? ""] ?? SongQuality.high;
    qualityWifi = wifi ?? "160kbps";
    qualityObjMd = qualityMap[md ?? ""] ?? SongQuality.medium;
    qualityMd = md ?? "96kbps";
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
  static Future<void> setSongQualityMd(SongQuality quality) async{
    qualityObjMd = quality;
    for(String key in qualityMap.keys){
      if(qualityMap[key] == quality){
        AppSettings.qualityMd = key;
      }
    }
    await LocalDataService.setSongQualityMd(AppSettings.qualityMd);
  }
}