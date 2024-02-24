// To parse this JSON data, do
//
//     final songDetails = songDetailsFromJson(jsonString);

import 'dart:convert';
import 'song.dart';

SongDetails songDetailsFromJson(String str) =>
    SongDetails.fromJson(json.decode(str));

String songDetailsToJson(SongDetails data) => json.encode(data.toJson());

class SongDetails {
  String status;
  dynamic message;
  List<Song> data;

  SongDetails({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SongDetails.fromJson(Map<String, dynamic> json) => SongDetails(
        status: json["status"],
        message: json["message"],
        data: List<Song>.from(json["data"].map((x) => Song.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<Song>.from(data.map((x) => x.toJson())),
      };
}
