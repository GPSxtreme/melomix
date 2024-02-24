// To parse this JSON data, do
//
//     final searchAlbums = searchAlbumsFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/search/search_albums/album_search.dart';

SearchAlbums searchAlbumsFromJson(String str) =>
    SearchAlbums.fromJson(json.decode(str));

String searchAlbumsToJson(SearchAlbums data) => json.encode(data.toJson());

class SearchAlbums {
  String status;
  dynamic message;
  Data data;

  SearchAlbums({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SearchAlbums.fromJson(Map<String, dynamic> json) => SearchAlbums(
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
  List<AlbumSearch> results;

  Data({
    required this.total,
    required this.start,
    required this.results,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        start: json["start"],
        results: List<AlbumSearch>.from(
            json["results"].map((x) => AlbumSearch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "start": start,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
