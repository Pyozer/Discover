import 'dart:convert';

class RegisterPayload {
  String email;
  String password;
  String firstName;
  String lastName;

  RegisterPayload({this.email, this.password, this.firstName, this.lastName});

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "email_user": email,
        "password_user": password,
        "first_name_user": firstName,
        "last_name_user": lastName,
      };
}
