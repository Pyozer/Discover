import 'dart:convert';

import 'package:discover/models/comments/comment.dart';

class CommentsResponse {
  List<Comment> comments;

  CommentsResponse({this.comments});

  factory CommentsResponse.fromRawJson(String str) =>
      CommentsResponse.fromJson(json.decode(str));

  factory CommentsResponse.fromJson(Map<String, dynamic> json) =>
      CommentsResponse(
        comments: List<Comment>.from(
          json["comments"].map((x) => Comment.fromJson(x)),
        ),
      );
}
