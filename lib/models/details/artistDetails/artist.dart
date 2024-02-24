// To parse this JSON data, do
//
//     final artist = artistFromJson(jsonString);

import 'dart:convert';

import '../image.dart';

Artist artistFromJson(String str) => Artist.fromJson(json.decode(str));

String artistToJson(Artist data) => json.encode(data.toJson());

class Artist {
  String id;
  String name;
  String url;
  List<Image> image;
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

  Artist({
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

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
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
        availableLanguages:
            List<String>.from(json["availableLanguages"].map((x) => x)),
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
        "availableLanguages":
            List<dynamic>.from(availableLanguages.map((x) => x)),
        "isRadioPresent": isRadioPresent,
      };
}
