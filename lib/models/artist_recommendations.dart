// To parse this JSON data, do
//
//     final artistRecommendations = artistRecommendationsFromJson(jsonString);

import 'dart:convert';
import 'song.dart';
ArtistRecommendations artistRecommendationsFromJson(String str) => ArtistRecommendations.fromJson(json.decode(str));

String artistRecommendationsToJson(ArtistRecommendations data) => json.encode(data.toJson());

class ArtistRecommendations {
  String status;
  dynamic message;
  List<Song> data;

  ArtistRecommendations({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ArtistRecommendations.fromJson(Map<String, dynamic> json) => ArtistRecommendations(
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
