// To parse this JSON data, do
//
//     final playListSearch = playListSearchFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/details/image.dart';

PlayListSearch playListSearchFromJson(String str) =>
    PlayListSearch.fromJson(json.decode(str));

String playListSearchToJson(PlayListSearch data) => json.encode(data.toJson());

class PlayListSearch {
  String id;
  String userId;
  String name;
  String songCount;
  String username;
  String firstname;
  String lastname;
  String language;
  List<Image> image;
  String url;

  PlayListSearch({
    required this.id,
    required this.userId,
    required this.name,
    required this.songCount,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.language,
    required this.image,
    required this.url,
  });

  factory PlayListSearch.fromJson(Map<String, dynamic> json) => PlayListSearch(
        id: json["id"],
        userId: json["userId"],
        name: json["name"],
        songCount: json["songCount"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        language: json["language"],
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "name": name,
        "songCount": songCount,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "language": language,
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
        "url": url,
      };
}
