import 'dart:async';

import 'package:discover/models/auth/login_response.dart';
import 'package:discover/models/auth/request/login_payload.dart';
import 'package:discover/models/auth/request/register_payload.dart';
import 'package:discover/utils/api/base_api.dart';

class Api extends BaseApi {
  Api() : super("http://10.3.0.192:3000/api/");

  /// Register user
  Future<LoginResponse> register(RegisterPayload payload) async {
    final response = await httpPost(
      getUrl("/users"),
      body: payload.toRawJson(),
    );
    return LoginResponse.fromJson(getWithBaseData(response));
  }

  /// Login user
  Future<LoginResponse> login(LoginPayload payload) async {
    final response = await httpPost(
      getUrl("/users/login"),
      body: payload.toRawJson(),
    );
    return LoginResponse.fromJson(getWithBaseData(response));
  }
}
