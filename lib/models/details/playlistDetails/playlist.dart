// To parse this JSON data, do
//
//     final playlist = playlistFromJson(jsonString);

import 'dart:convert';

import '../image.dart';
import '../songDetails/song.dart';

Playlist playlistFromJson(String str) => Playlist.fromJson(json.decode(str));

String playlistToJson(Playlist data) => json.encode(data.toJson());

class Playlist {
  String id;
  String userId;
  String name;
  String followerCount;
  String songCount;
  String fanCount;
  String username;
  String firstname;
  String lastname;
  String shares;
  List<Image> image;
  String url;
  List<Song> songs;
  Playlist({
    required this.id,
    required this.userId,
    required this.name,
    required this.followerCount,
    required this.songCount,
    required this.fanCount,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.shares,
    required this.image,
    required this.url,
    required this.songs,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        id: json["id"],
        userId: json["userId"],
        name: json["name"],
        followerCount: json["followerCount"],
        songCount: json["songCount"],
        fanCount: json["fanCount"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        shares: json["shares"],
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
        url: json["url"],
        songs: List<Song>.from(json["songs"].map((x) => Song.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "name": name,
        "followerCount": followerCount,
        "songCount": songCount,
        "fanCount": fanCount,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "shares": shares,
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
        "url": url,
        "songs": List<dynamic>.from(songs.map((x) => x.toJson())),
      };
}
