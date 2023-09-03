// To parse this JSON data, do
//
//     final songDetailsById = songDetailsByIdFromJson(jsonString);

import 'dart:convert';

import 'song.dart';

SongDetailsById songDetailsByIdFromJson(String str) => SongDetailsById.fromJson(json.decode(str));

String songDetailsByIdToJson(SongDetailsById data) => json.encode(data.toJson());

class SongDetailsById {
  String status;
  dynamic message;
  List<Song> data;

  SongDetailsById({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SongDetailsById.fromJson(Map<String, dynamic> json) => SongDetailsById(
    status: json["status"],
    message: json["message"],
    data: List<Song>.from(json["data"].map((x) => Song.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
