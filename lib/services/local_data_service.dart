import 'package:shared_preferences/shared_preferences.dart';

class LocalDataService{
  //setters
  static Future<void> setSongQualityWifi(String quality)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('songQualityWifi', quality);
  }
  static Future<void> setSongQualityMd(String quality)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('songQualityMd', quality);
  }
  static Future<void> setUserName(String userName)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName',  userName);
  }
  //getters
  static Future<String?> getSongQualityWifi()async{
    final prefs = await SharedPreferences.getInstance();
    String? quality = prefs.getString('songQualityWifi');
    return quality;
  }
  static Future<String?> getSongQualityMd()async{
    final prefs = await SharedPreferences.getInstance();
    String? quality = prefs.getString('songQualityMd');
    return quality;
  }
  static Future<String?> getUserName()async{
    final prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('userName');
    return userName;
  }
}