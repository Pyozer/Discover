import 'dart:convert';

import 'package:discover/models/tags/tag.dart';

class TagsResponse {
  List<Tag> tags;

  TagsResponse({this.tags});

  factory TagsResponse.fromRawJson(String str) =>
      TagsResponse.fromJson(json.decode(str));

  factory TagsResponse.fromJson(Map<String, dynamic> json) => TagsResponse(
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
      );
}
