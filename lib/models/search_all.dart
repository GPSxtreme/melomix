// To parse this JSON data, do
//
//     final searchAll = searchAllFromJson(jsonString);

import 'dart:convert';

import 'image_url.dart';

SearchAll searchAllFromJson(String str) => SearchAll.fromJson(json.decode(str));

String searchAllToJson(SearchAll data) => json.encode(data.toJson());

class SearchAll {
  String status;
  dynamic message;
  Data data;

  SearchAll({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SearchAll.fromJson(Map<String, dynamic> json) => SearchAll(
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
  TopQuery topQuery;
  Songs songs;
  Albums albums;
  Artists artists;
  Playlists playlists;

  Data({
    required this.topQuery,
    required this.songs,
    required this.albums,
    required this.artists,
    required this.playlists,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    topQuery: TopQuery.fromJson(json["topQuery"]),
    songs: Songs.fromJson(json["songs"]),
    albums: Albums.fromJson(json["albums"]),
    artists: Artists.fromJson(json["artists"]),
    playlists: Playlists.fromJson(json["playlists"]),
  );

  Map<String, dynamic> toJson() => {
    "topQuery": topQuery.toJson(),
    "songs": songs.toJson(),
    "albums": albums.toJson(),
    "artists": artists.toJson(),
    "playlists": playlists.toJson(),
  };
}

class Albums {
  List<AlbumsResult> results;
  int position;

  Albums({
    required this.results,
    required this.position,
  });

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
    results: List<AlbumsResult>.from(json["results"].map((x) => AlbumsResult.fromJson(x))),
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "position": position,
  };
}

class AlbumsResult {
  String id;
  String title;
  List<ImageUrl> image;
  String artist;
  String url;
  String type;
  String description;
  int position;
  String year;
  String songIds;
  String language;

  AlbumsResult({
    required this.id,
    required this.title,
    required this.image,
    required this.artist,
    required this.url,
    required this.type,
    required this.description,
    required this.position,
    required this.year,
    required this.songIds,
    required this.language,
  });

  factory AlbumsResult.fromJson(Map<String, dynamic> json) => AlbumsResult(
    id: json["id"],
    title: json["title"],
    image: List<ImageUrl>.from(json["image"].map((x) => ImageUrl.fromJson(x))),
    artist: json["artist"],
    url: json["url"],
    type: json["type"],
    description: json["description"],
    position: json["position"],
    year: json["year"],
    songIds: json["songIds"],
    language: json["language"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
    "artist": artist,
    "url": url,
    "type": type,
    "description": description,
    "position": position,
    "year": year,
    "songIds": songIds,
    "language": language,
  };
}


class Artists {
  List<ArtistsResult> results;
  int position;

  Artists({
    required this.results,
    required this.position,
  });

  factory Artists.fromJson(Map<String, dynamic> json) => Artists(
    results: List<ArtistsResult>.from(json["results"].map((x) => ArtistsResult.fromJson(x))),
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "position": position,
  };
}

class ArtistsResult {
  String id;
  String title;
  List<ImageUrl> image;
  String url;
  String type;
  String description;
  int position;

  ArtistsResult({
    required this.id,
    required this.title,
    required this.image,
    required this.url,
    required this.type,
    required this.description,
    required this.position,
  });

  factory ArtistsResult.fromJson(Map<String, dynamic> json) => ArtistsResult(
    id: json["id"],
    title: json["title"],
    image: List<ImageUrl>.from(json["image"].map((x) => ImageUrl.fromJson(x))),
    url: json["url"],
    type: json["type"],
    description: json["description"],
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
    "url": url,
    "type": type,
    "description": description,
    "position": position,
  };
}


class Playlists {
  List<PlaylistsResult> results;
  int position;

  Playlists({
    required this.results,
    required this.position,
  });

  factory Playlists.fromJson(Map<String, dynamic> json) => Playlists(
    results: List<PlaylistsResult>.from(json["results"].map((x) => PlaylistsResult.fromJson(x))),
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "position": position,
  };
}

class PlaylistsResult {
  String id;
  String title;
  List<ImageUrl> image;
  String url;
  String type;
  String language;
  String description;
  int position;

  PlaylistsResult({
    required this.id,
    required this.title,
    required this.image,
    required this.url,
    required this.type,
    required this.language,
    required this.description,
    required this.position,
  });

  factory PlaylistsResult.fromJson(Map<String, dynamic> json) => PlaylistsResult(
    id: json["id"],
    title: json["title"],
    image: List<ImageUrl>.from(json["image"].map((x) => ImageUrl.fromJson(x))),
    url: json["url"],
    type: json["type"],
    language: json["language"],
    description: json["description"],
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
    "url": url,
    "type": type,
    "language": language,
    "description": description,
    "position": position,
  };
}

class Songs {
  List<SongsResult> results;
  int position;

  Songs({
    required this.results,
    required this.position,
  });

  factory Songs.fromJson(Map<String, dynamic> json) => Songs(
    results: List<SongsResult>.from(json["results"].map((x) => SongsResult.fromJson(x))),
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "position": position,
  };
}

class SongsResult {
  String id;
  String title;
  List<ImageUrl> image;
  String album;
  String url;
  String type;
  String description;
  int position;
  String primaryArtists;
  String singers;
  String language;

  SongsResult({
    required this.id,
    required this.title,
    required this.image,
    required this.album,
    required this.url,
    required this.type,
    required this.description,
    required this.position,
    required this.primaryArtists,
    required this.singers,
    required this.language,
  });

  factory SongsResult.fromJson(Map<String, dynamic> json) => SongsResult(
    id: json["id"],
    title: json["title"],
    image: List<ImageUrl>.from(json["image"].map((x) => ImageUrl.fromJson(x))),
    album: json["album"],
    url: json["url"],
    type: json["type"],
    description: json["description"],
    position: json["position"],
    primaryArtists: json["primaryArtists"],
    singers: json["singers"],
    language: json["language"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
    "album": album,
    "url": url,
    "type": type,
    "description": description,
    "position": position,
    "primaryArtists": primaryArtists,
    "singers": singers,
    "language": language,
  };
}

class TopQuery {
  List<TopQueryResult> results;
  int position;

  TopQuery({
    required this.results,
    required this.position,
  });

  factory TopQuery.fromJson(Map<String, dynamic> json) => TopQuery(
    results: List<TopQueryResult>.from(json["results"].map((x) => TopQueryResult.fromJson(x))),
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "position": position,
  };
}

class TopQueryResult {
  String id;
  String title;
  List<ImageUrl> image;
  String url;
  String type;
  String description;
  int position;

  TopQueryResult({
    required this.id,
    required this.title,
    required this.image,
    required this.url,
    required this.type,
    required this.description,
    required this.position,
  });

  factory TopQueryResult.fromJson(Map<String, dynamic> json) => TopQueryResult(
    id: json["id"],
    title: json["title"],
    image: List<ImageUrl>.from(json["image"].map((x) => ImageUrl.fromJson(x))),
    url: json["url"],
    type: json["type"],
    description: json["description"],
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
    "url": url,
    "type": type,
    "description": description,
    "position": position,
  };
}
