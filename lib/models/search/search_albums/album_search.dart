// To parse this JSON data, do
//
//     final albumSearch = albumSearchFromJson(jsonString);

import 'dart:convert';
import 'package:proto_music_player/models/details/image.dart';

AlbumSearch albumSearchFromJson(String str) =>
    AlbumSearch.fromJson(json.decode(str));

String albumSearchToJson(AlbumSearch data) => json.encode(data.toJson());

class AlbumSearch {
  String id;
  String name;
  String year;
  String type;
  String playCount;
  String language;
  String explicitContent;
  String songCount;
  String url;
  List<Artist> primaryArtists;
  List<dynamic> featuredArtists;
  List<Artist> artists;
  List<Image> image;

  AlbumSearch({
    required this.id,
    required this.name,
    required this.year,
    required this.type,
    required this.playCount,
    required this.language,
    required this.explicitContent,
    required this.songCount,
    required this.url,
    required this.primaryArtists,
    required this.featuredArtists,
    required this.artists,
    required this.image,
  });

  factory AlbumSearch.fromJson(Map<String, dynamic> json) => AlbumSearch(
        id: json["id"],
        name: json["name"],
        year: json["year"],
        type: json["type"],
        playCount: json["playCount"],
        language: json["language"],
        explicitContent: json["explicitContent"],
        songCount: json["songCount"],
        url: json["url"],
        primaryArtists: List<Artist>.from(
            json["primaryArtists"].map((x) => Artist.fromJson(x))),
        featuredArtists:
            List<dynamic>.from(json["featuredArtists"].map((x) => x)),
        artists:
            List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "year": year,
        "type": type,
        "playCount": playCount,
        "language": language,
        "explicitContent": explicitContent,
        "songCount": songCount,
        "url": url,
        "primaryArtists":
            List<dynamic>.from(primaryArtists.map((x) => x.toJson())),
        "featuredArtists": List<dynamic>.from(featuredArtists.map((x) => x)),
        "artists": List<dynamic>.from(artists.map((x) => x.toJson())),
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
      };
}

class Artist {
  String id;
  String name;
  String url;
  bool image;
  Type type;
  Role role;

  Artist({
    required this.id,
    required this.name,
    required this.url,
    required this.image,
    required this.type,
    required this.role,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        image: json["image"],
        type: typeValues.map[json["type"]]!,
        role: roleValues.map[json["role"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "image": image,
        "type": typeValues.reverse[type],
        "role": roleValues.reverse[role],
      };
}

enum Role { MUSIC, PRIMARY_ARTISTS, SINGERS }

final roleValues = EnumValues({
  "music": Role.MUSIC,
  "primary_artists": Role.PRIMARY_ARTISTS,
  "singers": Role.SINGERS
});

enum Type { ARTIST }

final typeValues = EnumValues({"artist": Type.ARTIST});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
