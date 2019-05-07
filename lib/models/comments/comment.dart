import 'dart:convert';

class Comment {
  int id;
  int idPost;
  String text;
  DateTime date;
  int idUser;
  String firstNameUser;
  String lastNameUser;
  String photoUser;

  Comment({
    this.id,
    this.idPost,
    this.text,
    this.date,
    this.idUser,
    this.firstNameUser,
    this.lastNameUser,
    this.photoUser,
  });

  String get userInfo => "$firstNameUser $lastNameUser";

  factory Comment.fromRawJson(String str) => Comment.fromJson(json.decode(str));

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id_comment"],
        idPost: json["id_post"],
        text: json["text_comment"],
        date: DateTime.parse(json["date_comment"]),
        idUser: json["id_user"],
        firstNameUser: json["first_name_user"],
        lastNameUser: json["last_name_user"],
        photoUser: json["photo_user"],
      );
}
