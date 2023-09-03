import 'album.dart';
import 'download_url.dart';
import 'image_url.dart';

class Song {
  String id;
  String name;
  AlbumBasic album;
  String year;
  DateTime releaseDate;
  String duration;
  String label;
  String primaryArtists;
  String primaryArtistsId;
  String featuredArtists;
  String featuredArtistsId;
  int explicitContent;
  String playCount;
  String language;
  String hasLyrics;
  String url;
  String copyright;
  List<ImageUrl> image;
  List<DownloadUrl> downloadUrl;

  Song({
    required this.id,
    required this.name,
    required this.album,
    required this.year,
    required this.releaseDate,
    required this.duration,
    required this.label,
    required this.primaryArtists,
    required this.primaryArtistsId,
    required this.featuredArtists,
    required this.featuredArtistsId,
    required this.explicitContent,
    required this.playCount,
    required this.language,
    required this.hasLyrics,
    required this.url,
    required this.copyright,
    required this.image,
    required this.downloadUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) => Song(
    id: json["id"],
    name: json["name"],
    album: AlbumBasic.fromJson(json["album"]),
    year: json["year"],
    releaseDate: DateTime.parse(json["releaseDate"]),
    duration: json["duration"],
    label: json["label"],
    primaryArtists: json["primaryArtists"],
    primaryArtistsId: json["primaryArtistsId"],
    featuredArtists: json["featuredArtists"],
    featuredArtistsId: json["featuredArtistsId"],
    explicitContent: json["explicitContent"],
    playCount: json["playCount"],
    language: json["language"],
    hasLyrics: json["hasLyrics"],
    url: json["url"],
    copyright: json["copyright"],
    image: List<ImageUrl>.from(json["image"].map((x) => ImageUrl.fromJson(x))),
    downloadUrl: List<DownloadUrl>.from(json["downloadUrl"].map((x) => DownloadUrl.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "album": album.toJson(),
    "year": year,
    "releaseDate": "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
    "duration": duration,
    "label": label,
    "primaryArtists": primaryArtists,
    "primaryArtistsId": primaryArtistsId,
    "featuredArtists": featuredArtists,
    "featuredArtistsId": featuredArtistsId,
    "explicitContent": explicitContent,
    "playCount": playCount,
    "language": language,
    "hasLyrics": hasLyrics,
    "url": url,
    "copyright": copyright,
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
    "downloadUrl": List<dynamic>.from(downloadUrl.map((x) => x.toJson())),
  };
}