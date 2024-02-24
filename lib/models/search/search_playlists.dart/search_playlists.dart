// To parse this JSON data, do
//
//     final searchPlaylists = searchPlaylistsFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/search/search_playlists.dart/playlist_search.dart';

SearchPlaylists searchPlaylistsFromJson(String str) =>
    SearchPlaylists.fromJson(json.decode(str));

String searchPlaylistsToJson(SearchPlaylists data) =>
    json.encode(data.toJson());

class SearchPlaylists {
  String status;
  dynamic message;
  Data data;

  SearchPlaylists({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SearchPlaylists.fromJson(Map<String, dynamic> json) =>
      SearchPlaylists(
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
  List<PlayListSearch> results;

  Data({
    required this.total,
    required this.start,
    required this.results,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        start: json["start"],
        results: List<PlayListSearch>.from(
            json["results"].map((x) => PlayListSearch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "start": start,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
