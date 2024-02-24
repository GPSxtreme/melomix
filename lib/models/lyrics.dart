// To parse this JSON data, do
//
//     final lyrics = lyricsFromJson(jsonString);

import 'dart:convert';

Lyrics lyricsFromJson(String str) => Lyrics.fromJson(json.decode(str));

String lyricsToJson(Lyrics data) => json.encode(data.toJson());

class Lyrics {
  String status;
  dynamic message;
  Data data;

  Lyrics({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Lyrics.fromJson(Map<String, dynamic> json) => Lyrics(
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
  String lyrics;
  String snippet;
  String copyright;

  Data({
    required this.lyrics,
    required this.snippet,
    required this.copyright,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        lyrics: json["lyrics"],
        snippet: json["snippet"],
        copyright: json["copyright"],
      );

  Map<String, dynamic> toJson() => {
        "lyrics": lyrics,
        "snippet": snippet,
        "copyright": copyright,
      };
}
