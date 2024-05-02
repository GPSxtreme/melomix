// To parse this JSON data, do
//
//     final artistSearch = artistSearchFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/details/image.dart';

ArtistSearch artistSearchFromJson(String str) =>
    ArtistSearch.fromJson(json.decode(str));

String artistSearchToJson(ArtistSearch data) => json.encode(data.toJson());

class ArtistSearch {
  String id;
  String name;
  String url;
  String role;
  List<Image> image;
  bool isRadioPresent;

  ArtistSearch({
    required this.id,
    required this.name,
    required this.url,
    required this.role,
    required this.image,
    required this.isRadioPresent,
  });

  factory ArtistSearch.fromJson(Map<String, dynamic> json) => ArtistSearch(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        role: json["role"],
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
        isRadioPresent: json["isRadioPresent"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "role": role,
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
        "isRadioPresent": isRadioPresent,
      };
}
