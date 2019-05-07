import 'dart:convert';

class PostPayload {
  String content;
  String imageUrl;
  double latitude;
  double longitude;
  List<String> tags;

  PostPayload({
    this.content,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.tags,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "content_post": content,
        "image_url": imageUrl,
        "latitude_post": latitude?.toString(),
        "longitude_post": longitude?.toString(),
        "tags_post": tags,
      };
}
