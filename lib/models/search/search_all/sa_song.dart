// To parse this JSON data, do
//
//     final saSong = saSongFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/details/image.dart';

SaSong saSongFromJson(String str) => SaSong.fromJson(json.decode(str));

String saSongToJson(SaSong data) => json.encode(data.toJson());

class SaSong {
  String id;
  String title;
  List<Image> image;
  String album;
  String url;
  String type;
  String description;
  int position;
  String primaryArtists;
  String singers;
  String language;

  SaSong({
    required this.id,
    required this.title,
    required this.image,
    required this.album,
    required this.url,
    required this.type,
    required this.description,
    required this.position,
    required this.primaryArtists,
    required this.singers,
    required this.language,
  });

  factory SaSong.fromJson(Map<String, dynamic> json) => SaSong(
        id: json["id"],
        title: json["title"],
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
        album: json["album"],
        url: json["url"],
        type: json["type"],
        description: json["description"],
        position: json["position"],
        primaryArtists: json["primaryArtists"],
        singers: json["singers"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
        "album": album,
        "url": url,
        "type": type,
        "description": description,
        "position": position,
        "primaryArtists": primaryArtists,
        "singers": singers,
        "language": language,
      };
}
