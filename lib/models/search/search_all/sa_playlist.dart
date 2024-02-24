// To parse this JSON data, do
//
//     final saPlaylist = saPlaylistFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/details/image.dart';

SaPlaylist saPlaylistFromJson(String str) =>
    SaPlaylist.fromJson(json.decode(str));

String saPlaylistToJson(SaPlaylist data) => json.encode(data.toJson());

class SaPlaylist {
  String id;
  String title;
  List<Image> image;
  String url;
  String type;
  String language;
  String description;
  int position;

  SaPlaylist({
    required this.id,
    required this.title,
    required this.image,
    required this.url,
    required this.type,
    required this.language,
    required this.description,
    required this.position,
  });

  factory SaPlaylist.fromJson(Map<String, dynamic> json) => SaPlaylist(
        id: json["id"],
        title: json["title"],
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
        url: json["url"],
        type: json["type"],
        language: json["language"],
        description: json["description"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
        "url": url,
        "type": type,
        "language": language,
        "description": description,
        "position": position,
      };
}
