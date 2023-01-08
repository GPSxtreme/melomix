import 'dart:core';
import 'dart:typed_data';

class LocalSongData{
  final bool isLocal;
  final String id;
  final int intId;
  final String? songUri;
  final String name;
  final String? albumName;
  final String? primaryArtists;
  final String hasLyrics = "false";
  final Uint8List? artworkBytes;
  final String copyright = "";

  LocalSongData({required this.isLocal, required this.id, required this.intId, required this.songUri, required this.name, required this.albumName, required this.primaryArtists,required this.artworkBytes});

  Map<String,dynamic> get getMap =>{
    "isLocal" : isLocal,
    "id" : id,
    "intId" : intId,
    "songUri" : songUri,
    "name" : name,
    "albumName" : albumName,
    "primaryArtists" : primaryArtists,
    "hasLyrics" : hasLyrics,
    "artworkBytes" : artworkBytes,
    "copyright" : ""
  };
}