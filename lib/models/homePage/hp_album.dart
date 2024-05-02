// To parse this JSON data, do
//
//     final hpAlbum = hpAlbumFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/details/image.dart';

HpAlbum hpAlbumFromJson(String str) => HpAlbum.fromJson(json.decode(str));

String hpAlbumToJson(HpAlbum data) => json.encode(data.toJson());

class HpAlbum {
  String id;
  String name;
  String year;
  String playCount;
  String language;
  String explicitContent;
  List<Image> image;

  HpAlbum({
    required this.id,
    required this.name,
    required this.year,
    required this.playCount,
    required this.language,
    required this.explicitContent,
    required this.image,
  });

  factory HpAlbum.fromJson(Map<String, dynamic> json) => HpAlbum(
        id: json["id"],
        name: json["name"],
        year: json["year"],
        playCount: json["playCount"],
        language: json["language"],
        explicitContent: json["explicitContent"],
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "year": year,
        "playCount": playCount,
        "language": language,
        "explicitContent": explicitContent,
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
      };
}
