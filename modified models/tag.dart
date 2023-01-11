/// `Tag` class represent an ID3 Tag.
/// It represent both ID3V1 and ID3V2 tags.
class Tag {
  /// name of the track
  String? name;

  /// Artist of the track
  String? artist;

  /// Genre of the track
  String? genre;

  /// Number of the track in the album
  String? trackNumber;

  /// Total number of tracks in the album
  String? trackTotal;

  /// Number of the disc in the artist discography
  String? discNumber;

  /// Total number of discs in the artist discography
  String? discTotal;

  /// Lyrics of the track
  String? lyrics;

  /// Custom comment
  String? comment;

  /// Album of the track
  String? album;

  /// Artist of the album
  String? albumArtist;

  /// Year of publication
  String? year;

  /// Artwork path
  String? artwork;

  /// copyright of song
  String? copyright;

  /// Song id
  String? id;

  ///Explicit content
  String? explicitContent;

  ///Does song have lyrics
  String? hasLyrics;

  /// Default constructor
  Tag({
    this.name,
    this.artist,
    this.genre,
    this.trackNumber,
    this.trackTotal,
    this.discNumber,
    this.discTotal,
    this.lyrics,
    this.comment,
    this.album,
    this.albumArtist,
    this.year,
    this.artwork,
    this.id,
    this.hasLyrics,
    this.copyright,
    this.explicitContent
  });

  /// Create a `Tag` object from a `Map` of the tags.
  Tag.fromMap(Map map) {
    name = map["name"];
    artist = map["artist"];
    genre = map["genre"];
    trackNumber = map["trackNumber"];
    trackTotal = map["trackTotal"];
    discNumber = map["discNumber"];
    discTotal = map["discTotal"];
    lyrics = map["lyrics"];
    comment = map["comment"];
    album = map["album"];
    albumArtist = map["albumArtist"];
    year = map["year"];
    artwork = map["artwork"];
    id = map["id"];
    hasLyrics = map["hasLyrics"];
    copyright = map["copyright"];
    explicitContent = map["explicitContent"];
  }

  /// Get a `Map` of the tags from a `Tag` object.
  Map<String, String?> toMap() {
    return <String, String?>{
      "name": name,
      "artist": artist,
      "genre": genre,
      "trackNumber": trackNumber,
      "trackTotal": trackTotal,
      "discNumber": discNumber,
      "discTotal": discTotal,
      "lyrics": lyrics,
      "comment": comment,
      "album": album,
      "albumArtist": albumArtist,
      "year": year,
      "artwork": artwork,
      "id": id,
      "hasLyrics" : hasLyrics,
      "copyright" : copyright,
      "explicitContent" : explicitContent
    };
  }
}
