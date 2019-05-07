import 'dart:convert';
import 'package:discover/models/tags/tag.dart';
import 'package:discover/models/users/user.dart';
import 'package:discover/utils/functions.dart';

class Post {
  int id;
  String content;
  String photo;
  int distance;
  DateTime date;
  double latitude;
  double longitude;
  int likes;
  int comments;
  bool isUserLike;
  User author;
  List<Tag> tags;

  Post({
    this.id,
    this.content,
    this.photo,
    this.distance,
    this.date,
    this.latitude,
    this.longitude,
    this.likes,
    this.comments,
    this.isUserLike,
    this.author,
    this.tags,
  });

  String get dateAgo => getTimeAgo(this.date);
  String get distanceStr => getDistance(distance).toString();

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id_post"],
        content: json["content_post"],
        photo: json["photo_post"],
        distance: json["distance"],
        date: DateTime.parse(json["date_post"]),
        latitude: json["latitude_post"].toDouble(),
        longitude: json["longitude_post"].toDouble(),
        likes: json["likes_post"],
        comments: json["comments_post"],
        isUserLike: json["isUserLike"],
        author: User.fromJson(json["author_post"]),
        tags: json["tags_post"] != null
            ? List<Tag>.from(json["tags_post"].map((x) => Tag.fromJson(x)))
            : [],
      );
}
