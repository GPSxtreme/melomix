class Image {
  Quality quality;
  String link;

  Image({
    required this.quality,
    required this.link,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        quality: qualityValues.map[json["quality"]]!,
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "quality": qualityValues.reverse[quality],
        "link": link,
      };
}

enum Quality { THE_150_X150, THE_500_X500, THE_50_X50 }

final qualityValues = EnumValues({
  "150x150": Quality.THE_150_X150,
  "500x500": Quality.THE_500_X500,
  "50x50": Quality.THE_50_X50
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
