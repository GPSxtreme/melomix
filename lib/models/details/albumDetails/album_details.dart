// To parse this JSON data, do
//
//     final albumDetails = albumDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/details/albumDetails/album.dart';

AlbumDetails albumDetailsFromJson(String str) =>
    AlbumDetails.fromJson(json.decode(str));

String albumDetailsToJson(AlbumDetails data) => json.encode(data.toJson());

class AlbumDetails {
  String status;
  dynamic message;
  List<Album> data;

  AlbumDetails({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AlbumDetails.fromJson(Map<String, dynamic> json) => AlbumDetails(
        status: json["status"],
        message: json["message"],
        data: List<Album>.from(json["data"].map((x) => Album.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
