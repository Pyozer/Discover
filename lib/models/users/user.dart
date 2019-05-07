import 'dart:convert';

class User {
  String tokenUser;
  int idUser;
  String firstNameUser;
  String lastNameUser;
  String emailUser;
  String photoUser;

  User({
    this.tokenUser,
    this.idUser,
    this.firstNameUser,
    this.lastNameUser,
    this.emailUser,
    this.photoUser,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
        tokenUser: json["token_user"],
        idUser: json["id_user"],
        firstNameUser: json["first_name_user"],
        lastNameUser: json["last_name_user"],
        emailUser: json["email_user"],
        photoUser: json["photo_user"],
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "token_user": tokenUser,
        "id_user": idUser,
        "first_name_user": firstNameUser,
        "last_name_user": lastNameUser,
        "email_user": emailUser,
        "photo_user": photoUser
      };
}
