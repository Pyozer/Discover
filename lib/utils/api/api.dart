import 'dart:async';
import 'package:discover/models/users/request/login_payload.dart';
import 'package:discover/models/users/request/register_payload.dart';
import 'package:discover/models/users/user.dart';
import 'package:discover/models/posts/posts_response.dart';
import 'package:discover/models/posts/request/post_location_payload.dart';
import 'package:discover/utils/api/base_api.dart';

class Api extends BaseApi {
  Api() : super("https://discoverapi.herokuapp.com/api/");

  /// Register user
  Future<User> register(RegisterPayload payload) async {
    final response = await httpPost(
      getUrl("/users"),
      body: payload.toRawJson(),
    );
    return User.fromJson(getWithBaseData(response));
  }

  /// Login user
  Future<User> login(LoginPayload payload) async {
    final response = await httpPost(
      getUrl("/users/login"),
      body: payload.toRawJson(),
    );
    return User.fromJson(getWithBaseData(response));
  }

  /// Get post location
  Future<PostsResponse> postLocation(PostsLocationPayload payload) async {
    final response = await httpGet(
      getUrl("/posts/location", payload.toJson()),
    );
    return PostsResponse.fromJson(getWithBaseData(response));
  }
}
