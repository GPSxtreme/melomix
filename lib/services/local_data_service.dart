import 'package:flutter/foundation.dart';
import 'package:proto_music_player/services/app_settings.dart';
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
  static Future<void> setDataSaver(bool val)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDataSaver", val);
  }
  static Future<void> setAllowExplicit(bool val)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("allowExplicit", val);
  }
  static Future<void> setVolumeLevel(String level)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("volumeLevel", level);
  }
  ///Replaces the saved languages string with the given string.
  static Future<void> setLanguage(String languageString)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languages', languageString);
  }
  ///Adds given language to the existing language list.
  static Future<void> addLanguage(String language)async{
    List langList = await getLanguages();
    String langString = "";
    if(language.trim().isNotEmpty && langList.isNotEmpty){
      langList.add(language);
      for(int i = 0 ; i < langList.length;i++){
        if(i == langList.length - 1){
          langString += langList[i];
        }else{
          langString += "${langList[i]},";
        }
      }
      await setLanguage(langString);
    }else if(langList.isEmpty && language.trim().isNotEmpty){
      await setLanguage("$language,");
    }
    if (kDebugMode) {
      print(await getLanguages());
    }
  }
  static Future<void> removeLanguage(String language)async{
    List langList = await getLanguages();
    langList.remove(language);
    String langString = "";
    for(int i = 0 ; i < langList.length;i++){
      if(i == langList.length - 1){
        langString += langList[i];
      }else{
        langString += "${langList[i]},";
      }
    }
    setLanguage(langString);
    if (kDebugMode) {
      print(await getLanguages());
    }
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
  static Future<String?> getLanguagesString()async{
    final prefs = await SharedPreferences.getInstance();
    String? languages = prefs.getString('languages');
    return languages;
  }
  static Future<List> getLanguages()async{
    final prefs = await SharedPreferences.getInstance();
    String? languages = prefs.getString('languages');
    if(languages != null && languages.trim().isNotEmpty) {
      List data = languages.split(",");
      data.removeWhere((item) => [" ",",",""].contains(item));
      return data;
    } else {
      return [];
    }
  }
  static Future<bool> getIsDataSaver()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isDataSaver") ?? false;
  }
  static Future<bool> getAllowExplicit()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("allowExplicit") ?? true;
  }
  static Future<String> getVolumeLevel()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("volumeLevel") ?? VolumeLevel.normal.name;
  }
}