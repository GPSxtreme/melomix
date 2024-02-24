// To parse this JSON data, do
//
//     final Song = songDataFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/details/download_url.dart';
import 'package:proto_music_player/models/details/image.dart';

Song songDataFromJson(String str) => Song.fromJson(json.decode(str));

String songDataToJson(Song data) => json.encode(data.toJson());

class Song {
  String id;
  String name;
  String type;
  SongAlbum album;
  String year;
  dynamic releaseDate;
  String duration;
  String label;
  String primaryArtists;
  String primaryArtistsId;
  String featuredArtists;
  String featuredArtistsId;
  int explicitContent;
  String playCount;
  String language;
  String hasLyrics;
  String url;
  String copyright;
  List<Image> image;
  List<DownloadUrl> downloadUrl;

  Song({
    required this.id,
    required this.name,
    required this.type,
    required this.album,
    required this.year,
    required this.releaseDate,
    required this.duration,
    required this.label,
    required this.primaryArtists,
    required this.primaryArtistsId,
    required this.featuredArtists,
    required this.featuredArtistsId,
    required this.explicitContent,
    required this.playCount,
    required this.language,
    required this.hasLyrics,
    required this.url,
    required this.copyright,
    required this.image,
    required this.downloadUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        album: SongAlbum.fromJson(json["album"]),
        year: json["year"],
        releaseDate: json["releaseDate"],
        duration: json["duration"],
        label: json["label"],
        primaryArtists: json["primaryArtists"],
        primaryArtistsId: json["primaryArtistsId"],
        featuredArtists: json["featuredArtists"],
        featuredArtistsId: json["featuredArtistsId"],
        explicitContent: json["explicitContent"],
        playCount: json["playCount"],
        language: json["language"],
        hasLyrics: json["hasLyrics"],
        url: json["url"],
        copyright: json["copyright"],
        image:
            List<Image>.from(json["image"].map((x) => DownloadUrl.fromJson(x))),
        downloadUrl: List<DownloadUrl>.from(
            json["downloadUrl"].map((x) => DownloadUrl.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "album": album.toJson(),
        "year": year,
        "releaseDate": releaseDate,
        "duration": duration,
        "label": label,
        "primaryArtists": primaryArtists,
        "primaryArtistsId": primaryArtistsId,
        "featuredArtists": featuredArtists,
        "featuredArtistsId": featuredArtistsId,
        "explicitContent": explicitContent,
        "playCount": playCount,
        "language": language,
        "hasLyrics": hasLyrics,
        "url": url,
        "copyright": copyright,
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
        "downloadUrl": List<dynamic>.from(downloadUrl.map((x) => x.toJson())),
      };
}

class SongAlbum {
  String id;
  String name;
  String url;

  SongAlbum({
    required this.id,
    required this.name,
    required this.url,
  });

  factory SongAlbum.fromJson(Map<String, dynamic> json) => SongAlbum(
        id: json["id"],
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
      };
}
