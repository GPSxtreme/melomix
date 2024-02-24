// To parse this JSON data, do
//
//     final playlistDetails = playlistDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/details/playlistDetails/playlist.dart';

PlaylistDetails playlistDetailsFromJson(String str) =>
    PlaylistDetails.fromJson(json.decode(str));

String playlistDetailsToJson(PlaylistDetails data) =>
    json.encode(data.toJson());

class PlaylistDetails {
  String status;
  dynamic message;
  Playlist data;

  PlaylistDetails({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PlaylistDetails.fromJson(Map<String, dynamic> json) =>
      PlaylistDetails(
        status: json["status"],
        message: json["message"],
        data: Playlist.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}
