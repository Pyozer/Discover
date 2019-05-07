import 'dart:convert';

class User {
  String token;
  int id;
  String firstName;
  String lastName;
  String email;
  String photo;

  User({
    this.token,
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.photo,
  });

  String get userInfo => "$firstName $lastName";
  
  bool get isValid =>
      token != null &&
      id != null &&
      firstName != null &&
      lastName != null &&
      email != null;

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
        token: json["token_user"],
        id: json["id_user"],
        firstName: json["first_name_user"],
        lastName: json["last_name_user"],
        email: json["email_user"],
        photo: json["photo_user"],
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "token_user": token,
        "id_user": id,
        "first_name_user": firstName,
        "last_name_user": lastName,
        "email_user": email,
        "photo_user": photo
      };
}
