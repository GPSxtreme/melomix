import 'image_url.dart';

class Artist {
  String id;
  String name;
  String url;
  List<ImageUrl> image;
  String type;
  String role;

  Artist({
    required this.id,
    required this.name,
    required this.url,
    required this.image,
    required this.type,
    required this.role,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
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
