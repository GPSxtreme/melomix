// To parse this JSON data, do
//
//     final artistDetails = artistDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/search/search_albums/album_search.dart';

ArtistDetails artistDetailsFromJson(String str) =>
    ArtistDetails.fromJson(json.decode(str));

String artistDetailsToJson(ArtistDetails data) => json.encode(data.toJson());

class ArtistDetails {
  String status;
  dynamic message;
  Artist data;

  ArtistDetails({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ArtistDetails.fromJson(Map<String, dynamic> json) => ArtistDetails(
        status: json["status"],
        message: json["message"],
        data: Artist.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}
