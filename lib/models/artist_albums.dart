// To parse this JSON data, do
//
//     final artistAlbums = artistAlbumsFromJson(jsonString);

import 'dart:convert';

import 'album.dart';

ArtistAlbums artistAlbumsFromJson(String str) => ArtistAlbums.fromJson(json.decode(str));

String artistAlbumsToJson(ArtistAlbums data) => json.encode(data.toJson());

class ArtistAlbums {
  String status;
  dynamic message;
  Data data;

  ArtistAlbums({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ArtistAlbums.fromJson(Map<String, dynamic> json) => ArtistAlbums(
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
  int total;
  bool lastPage;
  List<Album> results;

  Data({
    required this.total,
    required this.lastPage,
    required this.results,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    total: json["total"],
    lastPage: json["lastPage"],
    results: List<Album>.from(json["results"].map((x) => Album.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "lastPage": lastPage,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}


