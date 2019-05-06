import 'dart:convert';

class LoginPayload {
  String email;
  String password;

  LoginPayload({this.email, this.password});

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() =>
      {"email_user": email, "password_user": password};
}
