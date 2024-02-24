// To parse this JSON data, do
//
//     final searchArtists = searchArtistsFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/search/search_artists/artist_search.dart';

SearchArtists searchArtistsFromJson(String str) =>
    SearchArtists.fromJson(json.decode(str));

String searchArtistsToJson(SearchArtists data) => json.encode(data.toJson());

class SearchArtists {
  String status;
  dynamic message;
  Data data;

  SearchArtists({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SearchArtists.fromJson(Map<String, dynamic> json) => SearchArtists(
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
  List<ArtistSearch> results;

  Data({
    required this.total,
    required this.start,
    required this.results,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        start: json["start"],
        results: List<ArtistSearch>.from(
            json["results"].map((x) => ArtistSearch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "start": start,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
