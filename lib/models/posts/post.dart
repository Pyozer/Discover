import 'dart:convert';
import 'package:discover/models/tags/tag.dart';
import 'package:discover/models/users/user.dart';

class Post {
  int idPost;
  String contentPost;
  String photoPost;
  double distance;
  DateTime datePost;
  double latitudePost;
  double longitudePost;
  int likesPost;
  int commentsPost;
  int isUserLike;
  User authorPost;
  List<Tag> tags;

  Post({
    this.idPost,
    this.contentPost,
    this.photoPost,
    this.distance,
    this.datePost,
    this.latitudePost,
    this.longitudePost,
    this.likesPost,
    this.commentsPost,
    this.isUserLike,
    this.authorPost,
    this.tags,
  });

  String get dateAgo => datePost.toString()/*getTimeAgo(this.datePost)*/;
  String get distanceStr => distance.toString()/*getTimeAgo(this.datePost)*/;

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        idPost: json["id_post"],
        contentPost: json["content_post"],
        photoPost: json["photo_post"],
        distance: json["distance"],
        datePost: DateTime.parse(json["date_post"]),
        latitudePost: json["latitude_post"].toDouble(),
        longitudePost: json["longitude_post"].toDouble(),
        likesPost: json["likes_post"],
        commentsPost: json["comments_post"],
        isUserLike: json["isUserLike"],
        authorPost: User.fromJson(json["author_post"]),
        tags: json["tags_post"] != null
            ? List<Tag>.from(json["tags_post"].map((x) => Tag.fromJson(x)))
            : [],
      );
}
