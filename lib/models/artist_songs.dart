// To parse this JSON data, do
//
//     final artistSongs = artistSongsFromJson(jsonString);

import 'dart:convert';
import 'song.dart';

ArtistSongs artistSongsFromJson(String str) => ArtistSongs.fromJson(json.decode(str));

String artistSongsToJson(ArtistSongs data) => json.encode(data.toJson());

class ArtistSongs {
  String status;
  dynamic message;
  Data data;

  ArtistSongs({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ArtistSongs.fromJson(Map<String, dynamic> json) => ArtistSongs(
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
  List<Song> results;

  Data({
    required this.total,
    required this.lastPage,
    required this.results,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    total: json["total"],
    lastPage: json["lastPage"],
    results: List<Song>.from(json["results"].map((x) => Song.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "lastPage": lastPage,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

