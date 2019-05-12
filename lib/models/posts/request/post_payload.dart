import 'dart:convert';

import 'package:discover/models/tags/tag.dart';

class PostPayload {
  String content;
  String infos;
  String imageUrl;
  double latitude;
  double longitude;
  List<Tag> tags;

  PostPayload({
    this.content,
    this.infos,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.tags,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "content_post": content,
        "info_post": infos,
        "content_post": content,
        "image_url": imageUrl,
        "latitude_post": latitude?.toString(),
        "longitude_post": longitude?.toString(),
        "tags_post": "[" + tags.map((x) => x.id).join(',') + "]",
      };
}
