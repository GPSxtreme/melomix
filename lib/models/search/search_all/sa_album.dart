// To parse this JSON data, do
//
//     final saAlbum = saAlbumFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/details/image.dart';

SaAlbum saAlbumFromJson(String str) => SaAlbum.fromJson(json.decode(str));

String saAlbumToJson(SaAlbum data) => json.encode(data.toJson());

class SaAlbum {
  String id;
  String title;
  List<Image> image;
  String artist;
  String url;
  String type;
  String description;
  int position;
  String year;
  String songIds;
  String language;

  SaAlbum({
    required this.id,
    required this.title,
    required this.image,
    required this.artist,
    required this.url,
    required this.type,
    required this.description,
    required this.position,
    required this.year,
    required this.songIds,
    required this.language,
  });

  factory SaAlbum.fromJson(Map<String, dynamic> json) => SaAlbum(
        id: json["id"],
        title: json["title"],
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
        artist: json["artist"],
        url: json["url"],
        type: json["type"],
        description: json["description"],
        position: json["position"],
        year: json["year"],
        songIds: json["songIds"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
        "artist": artist,
        "url": url,
        "type": type,
        "description": description,
        "position": position,
        "year": year,
        "songIds": songIds,
        "language": language,
      };
}
