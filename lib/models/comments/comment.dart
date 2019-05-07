import 'dart:convert';

class Comment {
  int idComment;
  int idPost;
  String textComment;
  DateTime dateComment;
  int idUser;
  String firstNameUser;
  String lastNameUser;
  String photoUser;

  Comment({
    this.idComment,
    this.idPost,
    this.textComment,
    this.dateComment,
    this.idUser,
    this.firstNameUser,
    this.lastNameUser,
    this.photoUser,
  });

  factory Comment.fromRawJson(String str) => Comment.fromJson(json.decode(str));

  factory Comment.fromJson(Map<String, dynamic> json) => new Comment(
        idComment: json["id_comment"],
        idPost: json["id_post"],
        textComment: json["text_comment"],
        dateComment: DateTime.parse(json["date_comment"]),
        idUser: json["id_user"],
        firstNameUser: json["first_name_user"],
        lastNameUser: json["last_name_user"],
        photoUser: json["photo_user"],
      );
}
