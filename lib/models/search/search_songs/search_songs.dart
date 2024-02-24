// To parse this JSON data, do
//
//     final searchSongs = searchSongsFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/details/songDetails/song.dart';

SearchSongs searchSongsFromJson(String str) =>
    SearchSongs.fromJson(json.decode(str));

String searchSongsToJson(SearchSongs data) => json.encode(data.toJson());

class SearchSongs {
  String status;
  dynamic message;
  Data data;

  SearchSongs({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SearchSongs.fromJson(Map<String, dynamic> json) => SearchSongs(
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
  int start;
  List<Song> results;

  Data({
    required this.total,
    required this.start,
    required this.results,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        start: json["start"],
        results: List<Song>.from(json["results"].map((x) => Song.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "start": start,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
