import 'dart:convert';

import 'package:discover/models/posts/post.dart';

class PostsResponse {
  List<Post> posts;

  PostsResponse({this.posts});

  factory PostsResponse.fromRawJson(String str) =>
      PostsResponse.fromJson(json.decode(str));

  factory PostsResponse.fromJson(Map<String, dynamic> json) => PostsResponse(
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
      );
}
