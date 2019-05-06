import 'dart:convert';

class LoginResponse {
  String tokenUser;
  int idUser;
  String firstNameUser;
  String lastNameUser;
  String emailUser;
  String photoUser;

  LoginResponse({
    this.tokenUser,
    this.idUser,
    this.firstNameUser,
    this.lastNameUser,
    this.emailUser,
    this.photoUser,
  });

  factory LoginResponse.fromRawJson(String str) =>
      LoginResponse.fromJson(json.decode(str));

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        tokenUser: json["token_user"],
        idUser: json["id_user"],
        firstNameUser: json["first_name_user"],
        lastNameUser: json["last_name_user"],
        emailUser: json["email_user"],
        photoUser: json["photo_user"],
      );
}
