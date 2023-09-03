// To parse this JSON data, do
//
//     final albumById = albumByIdFromJson(jsonString);

import 'dart:convert';
import 'image_url.dart';
import 'song.dart';

AlbumById albumByIdFromJson(String str) => AlbumById.fromJson(json.decode(str));

String albumByIdToJson(AlbumById data) => json.encode(data.toJson());

class AlbumById {
  String status;
  dynamic message;
  Data data;

  AlbumById({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AlbumById.fromJson(Map<String, dynamic> json) => AlbumById(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String id;
  String name;
  String year;
  DateTime releaseDate;
  String songCount;
  String url;
  String primaryArtistsId;
  String primaryArtists;
  List<dynamic> featuredArtists;
  List<dynamic> artists;
  List<ImageUrl> image;
  List<Song> songs;

  Data({
    required this.id,
    required this.name,
    required this.year,
    required this.releaseDate,
    required this.songCount,
    required this.url,
    required this.primaryArtistsId,
    required this.primaryArtists,
    required this.featuredArtists,
    required this.artists,
    required this.image,
    required this.songs,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    year: json["year"],
    releaseDate: DateTime.parse(json["releaseDate"]),
    songCount: json["songCount"],
    url: json["url"],
    primaryArtistsId: json["primaryArtistsId"],
    primaryArtists: json["primaryArtists"],
    featuredArtists: List<dynamic>.from(json["featuredArtists"].map((x) => x)),
    artists: List<dynamic>.from(json["artists"].map((x) => x)),
    image: List<ImageUrl>.from(json["image"].map((x) => ImageUrl.fromJson(x))),
    songs: List<Song>.from(json["songs"].map((x) => Song.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "year": year,
    "releaseDate": "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
    "songCount": songCount,
    "url": url,
    "primaryArtistsId": primaryArtistsId,
    "primaryArtists": primaryArtists,
    "featuredArtists": List<dynamic>.from(featuredArtists.map((x) => x)),
    "artists": List<dynamic>.from(artists.map((x) => x)),
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
    "songs": List<dynamic>.from(songs.map((x) => x.toJson())),
  };
}





