import 'artist.dart';
import 'image_url.dart';

class AlbumBasic {
  String id;
  String name;
  String url;

  AlbumBasic({
    required this.id,
    required this.name,
    required this.url,
  });

  factory AlbumBasic.fromJson(Map<String, dynamic> json) => AlbumBasic(
    id: json["id"],
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
  };
}

class Album {
  String id;
  String name;
  String year;
  String playCount;
  String language;
  String explicitContent;
  String songCount;
  String url;
  List<Artist> primaryArtists;
  List<dynamic> featuredArtists;
  List<Artist> artists;
  List<ImageUrl> image;
  List<dynamic> songs;

  Album({
    required this.id,
    required this.name,
    required this.year,
    required this.playCount,
    required this.language,
    required this.explicitContent,
    required this.songCount,
    required this.url,
    required this.primaryArtists,
    required this.featuredArtists,
    required this.artists,
    required this.image,
    required this.songs,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    id: json["id"],
    name: json["name"],
    year: json["year"],
    playCount: json["playCount"],
    language: json["language"],
    explicitContent: json["explicitContent"],
    songCount: json["songCount"],
    url: json["url"],
    primaryArtists: List<Artist>.from(json["primaryArtists"].map((x) => Artist.fromJson(x))),
    featuredArtists: List<dynamic>.from(json["featuredArtists"].map((x) => x)),
    artists: List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
    image: List<ImageUrl>.from(json["image"].map((x) => ImageUrl.fromJson(x))),
    songs: List<dynamic>.from(json["songs"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "year": year,
    "playCount": playCount,
    "language": language,
    "explicitContent": explicitContent,
    "songCount": songCount,
    "url": url,
    "primaryArtists": List<dynamic>.from(primaryArtists.map((x) => x.toJson())),
    "featuredArtists": List<dynamic>.from(featuredArtists.map((x) => x)),
    "artists": List<dynamic>.from(artists.map((x) => x.toJson())),
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
    "songs": List<dynamic>.from(songs.map((x) => x)),
  };
}
