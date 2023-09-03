// To parse this JSON data, do
//
//     final homePageData = homePageDataFromJson(jsonString);

import 'dart:convert';

HomePageData homePageDataFromJson(String str) => HomePageData.fromJson(json.decode(str));

String homePageDataToJson(HomePageData data) => json.encode(data.toJson());

class HomePageData {
  String status;
  dynamic message;
  Data data;

  HomePageData({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HomePageData.fromJson(Map<String, dynamic> json) => HomePageData(
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
  List<DataAlbum> albums;
  List<Playlist> playlists;
  List<Chart> charts;
  Trending trending;

  Data({
    required this.albums,
    required this.playlists,
    required this.charts,
    required this.trending,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    albums: List<DataAlbum>.from(json["albums"].map((x) => DataAlbum.fromJson(x))),
    playlists: List<Playlist>.from(json["playlists"].map((x) => Playlist.fromJson(x))),
    charts: List<Chart>.from(json["charts"].map((x) => Chart.fromJson(x))),
    trending: Trending.fromJson(json["trending"]),
  );

  Map<String, dynamic> toJson() => {
    "albums": List<dynamic>.from(albums.map((x) => x.toJson())),
    "playlists": List<dynamic>.from(playlists.map((x) => x.toJson())),
    "charts": List<dynamic>.from(charts.map((x) => x.toJson())),
    "trending": trending.toJson(),
  };
}

class DataAlbum {
  String id;
  String name;
  String year;
  String type;
  String playCount;
  String language;
  String explicitContent;
  String? songCount;
  String url;
  List<dynamic> primaryArtists;
  List<dynamic> featuredArtists;
  List<PurpleArtist> artists;
  List<ImageElement> image;
  List<dynamic> songs;

  DataAlbum({
    required this.id,
    required this.name,
    required this.year,
    required this.type,
    required this.playCount,
    required this.language,
    required this.explicitContent,
    this.songCount,
    required this.url,
    required this.primaryArtists,
    required this.featuredArtists,
    required this.artists,
    required this.image,
    required this.songs,
  });

  factory DataAlbum.fromJson(Map<String, dynamic> json) => DataAlbum(
    id: json["id"],
    name: json["name"],
    year: json["year"],
    type: json["type"],
    playCount: json["playCount"],
    language: json["language"],
    explicitContent: json["explicitContent"],
    songCount: json["songCount"],
    url: json["url"],
    primaryArtists: List<dynamic>.from(json["primaryArtists"].map((x) => x)),
    featuredArtists: List<dynamic>.from(json["featuredArtists"].map((x) => x)),
    artists: List<PurpleArtist>.from(json["artists"].map((x) => PurpleArtist.fromJson(x))),
    image: List<ImageElement>.from(json["image"].map((x) => ImageElement.fromJson(x))),
    songs: List<dynamic>.from(json["songs"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "year": year,
    "type": type,
    "playCount": playCount,
    "language": language,
    "explicitContent": explicitContent,
    "songCount": songCount,
    "url": url,
    "primaryArtists": List<dynamic>.from(primaryArtists.map((x) => x)),
    "featuredArtists": List<dynamic>.from(featuredArtists.map((x) => x)),
    "artists": List<dynamic>.from(artists.map((x) => x.toJson())),
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
    "songs": List<dynamic>.from(songs.map((x) => x)),
  };
}

class PurpleArtist {
  String id;
  String name;
  String url;
  dynamic image;
  String type;
  String role;

  PurpleArtist({
    required this.id,
    required this.name,
    required this.url,
    required this.image,
    required this.type,
    required this.role,
  });

  factory PurpleArtist.fromJson(Map<String, dynamic> json) => PurpleArtist(
    id: json["id"],
    name: json["name"],
    url: json["url"],
    image: json["image"],
    type: json["type"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
    "image": image,
    "type": type,
    "role": role,
  };
}

class ImageElement {
  String quality;
  String link;

  ImageElement({
    required this.quality,
    required this.link,
  });

  factory ImageElement.fromJson(Map<String, dynamic> json) => ImageElement(
    quality: json["quality"],
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "quality": quality,
    "link": link,
  };
}

class Chart {
  String id;
  String title;
  String subtitle;
  String type;
  List<ImageElement> image;
  String url;
  String firstname;
  String explicitContent;
  String language;

  Chart({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.image,
    required this.url,
    required this.firstname,
    required this.explicitContent,
    required this.language,
  });

  factory Chart.fromJson(Map<String, dynamic> json) => Chart(
    id: json["id"],
    title: json["title"],
    subtitle: json["subtitle"],
    type: json["type"],
    image: List<ImageElement>.from(json["image"].map((x) => ImageElement.fromJson(x))),
    url: json["url"],
    firstname: json["firstname"],
    explicitContent: json["explicitContent"],
    language: json["language"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "subtitle": subtitle,
    "type": type,
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
    "url": url,
    "firstname": firstname,
    "explicitContent": explicitContent,
    "language": language,
  };
}

class Playlist {
  String id;
  String userId;
  String title;
  String subtitle;
  String type;
  List<ImageElement> image;
  String url;
  String songCount;
  String firstname;
  String followerCount;
  String lastUpdated;
  String explicitContent;

  Playlist({
    required this.id,
    required this.userId,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.image,
    required this.url,
    required this.songCount,
    required this.firstname,
    required this.followerCount,
    required this.lastUpdated,
    required this.explicitContent,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
    id: json["id"],
    userId: json["userId"],
    title: json["title"],
    subtitle: json["subtitle"],
    type: json["type"],
    image: List<ImageElement>.from(json["image"].map((x) => ImageElement.fromJson(x))),
    url: json["url"],
    songCount: json["songCount"],
    firstname: json["firstname"],
    followerCount: json["followerCount"],
    lastUpdated: json["lastUpdated"],
    explicitContent: json["explicitContent"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "title": title,
    "subtitle": subtitle,
    "type": type,
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
    "url": url,
    "songCount": songCount,
    "firstname": firstname,
    "followerCount": followerCount,
    "lastUpdated": lastUpdated,
    "explicitContent": explicitContent,
  };
}

class Trending {
  List<Song> songs;
  List<TrendingAlbum> albums;

  Trending({
    required this.songs,
    required this.albums,
  });

  factory Trending.fromJson(Map<String, dynamic> json) => Trending(
    songs: List<Song>.from(json["songs"].map((x) => Song.fromJson(x))),
    albums: List<TrendingAlbum>.from(json["albums"].map((x) => TrendingAlbum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "songs": List<dynamic>.from(songs.map((x) => x.toJson())),
    "albums": List<dynamic>.from(albums.map((x) => x.toJson())),
  };
}

class TrendingAlbum {
  String id;
  String name;
  String type;
  String year;
  DateTime releaseDate;
  String playCount;
  String language;
  String explicitContent;
  String songCount;
  String url;
  List<dynamic> primaryArtists;
  List<dynamic> featuredArtists;
  List<PrimaryArtistElement> artists;
  List<ImageElement> image;

  TrendingAlbum({
    required this.id,
    required this.name,
    required this.type,
    required this.year,
    required this.releaseDate,
    required this.playCount,
    required this.language,
    required this.explicitContent,
    required this.songCount,
    required this.url,
    required this.primaryArtists,
    required this.featuredArtists,
    required this.artists,
    required this.image,
  });

  factory TrendingAlbum.fromJson(Map<String, dynamic> json) => TrendingAlbum(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    year: json["year"],
    releaseDate: DateTime.parse(json["releaseDate"]),
    playCount: json["playCount"],
    language: json["language"],
    explicitContent: json["explicitContent"],
    songCount: json["songCount"],
    url: json["url"],
    primaryArtists: List<dynamic>.from(json["primaryArtists"].map((x) => x)),
    featuredArtists: List<dynamic>.from(json["featuredArtists"].map((x) => x)),
    artists: List<PrimaryArtistElement>.from(json["artists"].map((x) => PrimaryArtistElement.fromJson(x))),
    image: List<ImageElement>.from(json["image"].map((x) => ImageElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "year": year,
    "releaseDate": "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
    "playCount": playCount,
    "language": language,
    "explicitContent": explicitContent,
    "songCount": songCount,
    "url": url,
    "primaryArtists": List<dynamic>.from(primaryArtists.map((x) => x)),
    "featuredArtists": List<dynamic>.from(featuredArtists.map((x) => x)),
    "artists": List<dynamic>.from(artists.map((x) => x.toJson())),
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
  };
}

class PrimaryArtistElement {
  String id;
  String name;
  String url;
  dynamic image;
  String type;
  String role;

  PrimaryArtistElement({
    required this.id,
    required this.name,
    required this.url,
    required this.image,
    required this.type,
    required this.role,
  });

  factory PrimaryArtistElement.fromJson(Map<String, dynamic> json) => PrimaryArtistElement(
    id: json["id"],
    name: json["name"],
    url: json["url"],
    image: json["image"],
    type: json["type"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
    "image": image,
    "type": type,
    "role": role,
  };
}

class Song {
  String id;
  String name;
  String type;
  SongAlbum album;
  String year;
  DateTime releaseDate;
  String duration;
  String label;
  List<PrimaryArtistElement> primaryArtists;
  List<dynamic> featuredArtists;
  String explicitContent;
  String playCount;
  String language;
  String url;
  List<ImageElement> image;

  Song({
    required this.id,
    required this.name,
    required this.type,
    required this.album,
    required this.year,
    required this.releaseDate,
    required this.duration,
    required this.label,
    required this.primaryArtists,
    required this.featuredArtists,
    required this.explicitContent,
    required this.playCount,
    required this.language,
    required this.url,
    required this.image,
  });

  factory Song.fromJson(Map<String, dynamic> json) => Song(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    album: SongAlbum.fromJson(json["album"]),
    year: json["year"],
    releaseDate: DateTime.parse(json["releaseDate"]),
    duration: json["duration"],
    label: json["label"],
    primaryArtists: List<PrimaryArtistElement>.from(json["primaryArtists"].map((x) => PrimaryArtistElement.fromJson(x))),
    featuredArtists: List<dynamic>.from(json["featuredArtists"].map((x) => x)),
    explicitContent: json["explicitContent"],
    playCount: json["playCount"],
    language: json["language"],
    url: json["url"],
    image: List<ImageElement>.from(json["image"].map((x) => ImageElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "album": album.toJson(),
    "year": year,
    "releaseDate": "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
    "duration": duration,
    "label": label,
    "primaryArtists": List<dynamic>.from(primaryArtists.map((x) => x.toJson())),
    "featuredArtists": List<dynamic>.from(featuredArtists.map((x) => x)),
    "explicitContent": explicitContent,
    "playCount": playCount,
    "language": language,
    "url": url,
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
  };
}

class SongAlbum {
  String id;
  String name;
  String url;

  SongAlbum({
    required this.id,
    required this.name,
    required this.url,
  });

  factory SongAlbum.fromJson(Map<String, dynamic> json) => SongAlbum(
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
