import 'dart:convert';
import 'package:discover/models/users/user.dart';

class Post {
  int idPost;
  String contentPost;
  String photoPost;
  DateTime datePost;
  double latitudePost;
  double longitudePost;
  int likesPost;
  int commentsPost;
  int isUserLike;
  User authorPost;

  Post({
    this.idPost,
    this.contentPost,
    this.photoPost,
    this.datePost,
    this.latitudePost,
    this.longitudePost,
    this.likesPost,
    this.commentsPost,
    this.isUserLike,
    this.authorPost,
  });

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        idPost: json["id_post"],
        contentPost: json["content_post"],
        photoPost: json["photo_post"],
        datePost: DateTime.parse(json["date_post"]),
        latitudePost: json["latitude_post"].toDouble(),
        longitudePost: json["longitude_post"].toDouble(),
        likesPost: json["likes_post"],
        commentsPost: json["comments_post"],
        isUserLike: json["isUserLike"],
        authorPost: User.fromJson(json["author_post"]),
      );
}
