class DownloadUrl {
  SongQuality quality;
  String link;

  DownloadUrl({
    required this.quality,
    required this.link,
  });

  factory DownloadUrl.fromJson(Map<String, dynamic> json) => DownloadUrl(
        quality: json["quality"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "quality": quality,
        "link": link,
      };
}

enum SongQuality {
  THE_12KBPS,
  THE_48KBPS,
  THE_96KBPS,
  THE_160KBPS,
  THE_320KBPS
}

final qualityValues = EnumValues({
  "128": SongQuality.THE_12KBPS,
  "160": SongQuality.THE_160KBPS,
  "320": SongQuality.THE_320KBPS,
  "48": SongQuality.THE_48KBPS,
  "96": SongQuality.THE_96KBPS
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
