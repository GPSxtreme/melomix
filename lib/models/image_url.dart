class ImageUrl {
  String quality;
  String link;

  ImageUrl({
    required this.quality,
    required this.link,
  });

  factory ImageUrl.fromJson(Map<String, dynamic> json) => ImageUrl(
    quality: json["quality"],
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "quality": quality,
    "link": link,
  };
}