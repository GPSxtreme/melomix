// To parse this JSON data, do
//
//     final songByQuery = songByQueryFromJson(jsonString);

import 'dart:convert';
import 'song.dart';

SongByQuery songByQueryFromJson(String str) => SongByQuery.fromJson(json.decode(str));

String songByQueryToJson(SongByQuery data) => json.encode(data.toJson());

class SongByQuery {
  String status;
  dynamic message;
  Data data;

  SongByQuery({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SongByQuery.fromJson(Map<String, dynamic> json) => SongByQuery(
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



