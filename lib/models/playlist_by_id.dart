// To parse this JSON data, do
//
//     final playlistById = playlistByIdFromJson(jsonString);

import 'dart:convert';
import 'image_url.dart';
import 'song.dart';

PlaylistById playlistByIdFromJson(String str) => PlaylistById.fromJson(json.decode(str));

String playlistByIdToJson(PlaylistById data) => json.encode(data.toJson());

class PlaylistById {
  String status;
  dynamic message;
  Data data;

  PlaylistById({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PlaylistById.fromJson(Map<String, dynamic> json) => PlaylistById(
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
  List<ImageUrl> image;
  String url;
  List<Song> songs;

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    image: List<ImageUrl>.from(json["image"].map((x) => ImageUrl.fromJson(x))),
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

