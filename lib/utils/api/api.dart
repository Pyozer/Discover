import 'dart:async';
import 'package:discover/models/users/request/login_payload.dart';
import 'package:discover/models/users/request/register_payload.dart';
import 'package:discover/models/users/user.dart';
import 'package:discover/models/posts/posts_response.dart';
import 'package:discover/models/posts/request/post_location_payload.dart';
import 'package:discover/utils/api/base_api.dart';

class Api extends BaseApi {
  Api() : super("http://10.3.0.149:3000/api/");

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

  /// Get post by location
  Future<PostsResponse> getPostByLocation(
    PostsLocationPayload payload,
    String token,
  ) async {
    final response = await httpGet(
      getUrl("/posts/location", payload.toJson()),
      token: token,
    );
    return PostsResponse.fromJson(getWithBaseData(response));
  }

  /// Get post
  Future<PostsResponse> getPost(int id, String token) async {
    final response = await httpGet(getUrl("/posts/$id"), token: token);
    return PostsResponse.fromJson(getWithBaseData(response));
  }
}
