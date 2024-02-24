// To parse this JSON data, do
//
//     final album = albumFromJson(jsonString);

import 'dart:convert';
import '../../Song.dart';
import '../image.dart';

Album albumFromJson(String str) => Album.fromJson(json.decode(str));

String albumToJson(Album data) => json.encode(data.toJson());

class Album {
  String id;
  String name;
  String year;
  DateTime releaseDate;
  String songCount;
  String url;
  String primaryArtistsId;
  String primaryArtists;
  List<Image> image;
  List<SongData> songs;

  Album({
    required this.id,
    required this.name,
    required this.year,
    required this.releaseDate,
    required this.songCount,
    required this.url,
    required this.primaryArtistsId,
    required this.primaryArtists,
    required this.image,
    required this.songs,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        id: json["id"],
        name: json["name"],
        year: json["year"],
        releaseDate: DateTime.parse(json["releaseDate"]),
        songCount: json["songCount"],
        url: json["url"],
        primaryArtistsId: json["primaryArtistsId"],
        primaryArtists: json["primaryArtists"],
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
        songs:
            List<SongData>.from(json["songs"].map((x) => SongData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "year": year,
        "releaseDate":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "songCount": songCount,
        "url": url,
        "primaryArtistsId": primaryArtistsId,
        "primaryArtists": primaryArtists,
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
        "songs": List<dynamic>.from(songs.map((x) => x.toJson())),
      };
}
