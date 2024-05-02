// To parse this JSON data, do
//
//     final hpPlaylist = hpPlaylistFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/details/image.dart';

HpPlaylist hpPlaylistFromJson(String str) =>
    HpPlaylist.fromJson(json.decode(str));

String hpPlaylistToJson(HpPlaylist data) => json.encode(data.toJson());

class HpPlaylist {
  String id;
  String title;
  String subtitle;
  List<Image> image;
  String explicitContent;

  HpPlaylist({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.explicitContent,
  });

  factory HpPlaylist.fromJson(Map<String, dynamic> json) => HpPlaylist(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
        explicitContent: json["explicitContent"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
        "explicitContent": explicitContent,
      };
}
