// To parse this JSON data, do
//
//     final artistDetailsById = artistDetailsByIdFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/image_url.dart';

ArtistDetailsById artistDetailsByIdFromJson(String str) => ArtistDetailsById.fromJson(json.decode(str));

String artistDetailsByIdToJson(ArtistDetailsById data) => json.encode(data.toJson());

class ArtistDetailsById {
  String status;
  dynamic message;
  Data data;

  ArtistDetailsById({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ArtistDetailsById.fromJson(Map<String, dynamic> json) => ArtistDetailsById(
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
  String name;
  String url;
  List<ImageUrl> image;
  String followerCount;
  String fanCount;
  bool isVerified;
  String dominantLanguage;
  String dominantType;
  List<dynamic> bio;
  String dob;
  String fb;
  String twitter;
  String wiki;
  List<String> availableLanguages;
  bool isRadioPresent;

  Data({
    required this.id,
    required this.name,
    required this.url,
    required this.image,
    required this.followerCount,
    required this.fanCount,
    required this.isVerified,
    required this.dominantLanguage,
    required this.dominantType,
    required this.bio,
    required this.dob,
    required this.fb,
    required this.twitter,
    required this.wiki,
    required this.availableLanguages,
    required this.isRadioPresent,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    url: json["url"],
    image: List<ImageUrl>.from(json["image"].map((x) => ImageUrl.fromJson(x))),
    followerCount: json["followerCount"],
    fanCount: json["fanCount"],
    isVerified: json["isVerified"],
    dominantLanguage: json["dominantLanguage"],
    dominantType: json["dominantType"],
    bio: List<dynamic>.from(json["bio"].map((x) => x)),
    dob: json["dob"],
    fb: json["fb"],
    twitter: json["twitter"],
    wiki: json["wiki"],
    availableLanguages: List<String>.from(json["availableLanguages"].map((x) => x)),
    isRadioPresent: json["isRadioPresent"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
    "followerCount": followerCount,
    "fanCount": fanCount,
    "isVerified": isVerified,
    "dominantLanguage": dominantLanguage,
    "dominantType": dominantType,
    "bio": List<dynamic>.from(bio.map((x) => x)),
    "dob": dob,
    "fb": fb,
    "twitter": twitter,
    "wiki": wiki,
    "availableLanguages": List<dynamic>.from(availableLanguages.map((x) => x)),
    "isRadioPresent": isRadioPresent,
  };
}
