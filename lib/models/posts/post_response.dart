import 'dart:convert';

import 'package:discover/models/auth/login_response.dart';

class PostResponse {
  int idPost;
  String contentPost;
  String photoPost;
  DateTime datePost;
  double latitudePost;
  double longitudePost;
  int likesPost;
  int commentsPost;
  int isUserLike;
  LoginResponse authorPost;

  PostResponse({
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

  factory PostResponse.fromRawJson(String str) =>
      PostResponse.fromJson(json.decode(str));

  factory PostResponse.fromJson(Map<String, dynamic> json) => PostResponse(
        idPost: json["id_post"],
        contentPost: json["content_post"],
        photoPost: json["photo_post"],
        datePost: DateTime.parse(json["date_post"]),
        latitudePost: json["latitude_post"].toDouble(),
        longitudePost: json["longitude_post"].toDouble(),
        likesPost: json["likes_post"],
        commentsPost: json["comments_post"],
        isUserLike: json["isUserLike"],
        authorPost: LoginResponse.fromJson(json["author_post"]),
      );
}
