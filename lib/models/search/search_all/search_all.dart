// To parse this JSON data, do
//
//     final searchAll = searchAllFromJson(jsonString);

import 'dart:convert';

import 'package:proto_music_player/models/search/search_all/sa_album.dart';
import 'package:proto_music_player/models/search/search_all/sa_artist.dart';
import 'package:proto_music_player/models/search/search_all/sa_playlist.dart';
import 'package:proto_music_player/models/search/search_all/sa_song.dart';

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
  dynamic topQuery;
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

  static dynamic resolveTopQueryToRespectiveMode(
      Map<String, dynamic> topQuery) {
    if (topQuery["type"] == "song") {
      return SaSong.fromJson(topQuery);
    } else if (topQuery["type"] == "album") {
      return SaAlbum.fromJson(topQuery);
    } else if (topQuery["type"] == "artist") {
      return SaArtist.fromJson(topQuery);
    } else if (topQuery["type"] == "playlist") {
      return SaPlaylist.fromJson(topQuery);
    }
    return null;
  }

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        topQuery: resolveTopQueryToRespectiveMode(json["topQuery"]),
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
  List<SaAlbum> results;
  int position;

  Albums({
    required this.results,
    required this.position,
  });

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
        results:
            List<SaAlbum>.from(json["results"].map((x) => SaAlbum.fromJson(x))),
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "position": position,
      };
}

class Artists {
  List<SaArtist> results;
  int position;

  Artists({
    required this.results,
    required this.position,
  });

  factory Artists.fromJson(Map<String, dynamic> json) => Artists(
        results: List<SaArtist>.from(
            json["results"].map((x) => SaArtist.fromJson(x))),
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "position": position,
      };
}

class Playlists {
  List<SaPlaylist> results;
  int position;

  Playlists({
    required this.results,
    required this.position,
  });

  factory Playlists.fromJson(Map<String, dynamic> json) => Playlists(
        results: List<SaPlaylist>.from(
            json["results"].map((x) => SaPlaylist.fromJson(x))),
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "position": position,
      };
}

class Songs {
  List<SaSong> results;
  int position;

  Songs({
    required this.results,
    required this.position,
  });

  factory Songs.fromJson(Map<String, dynamic> json) => Songs(
        results:
            List<SaSong>.from(json["results"].map((x) => SaSong.fromJson(x))),
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "position": position,
      };
}
