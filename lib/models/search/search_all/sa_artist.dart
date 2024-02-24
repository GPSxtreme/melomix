// To parse this JSON data, do
//
//     final saArtist = saArtistFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/details/image.dart';

SaArtist saArtistFromJson(String str) => SaArtist.fromJson(json.decode(str));

String saArtistToJson(SaArtist data) => json.encode(data.toJson());

class SaArtist {
  String id;
  String title;
  List<Image> image;
  String url;
  String type;
  String description;
  int position;

  SaArtist({
    required this.id,
    required this.title,
    required this.image,
    required this.url,
    required this.type,
    required this.description,
    required this.position,
  });

  factory SaArtist.fromJson(Map<String, dynamic> json) => SaArtist(
        id: json["id"],
        title: json["title"],
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
        url: json["url"],
        type: json["type"],
        description: json["description"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
        "url": url,
        "type": type,
        "description": description,
        "position": position,
      };
}
