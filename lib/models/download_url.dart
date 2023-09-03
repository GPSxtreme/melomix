class DownloadUrl {
  String quality;
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
