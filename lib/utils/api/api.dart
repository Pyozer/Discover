import 'dart:async';
import 'package:discover/models/comments/comments_response.dart';
import 'package:discover/models/comments/request/comment_payload.dart';
import 'package:discover/models/posts/request/post_payload.dart';
import 'package:discover/models/result_response.dart';
import 'package:discover/models/tags/tags_response.dart';
import 'package:discover/models/users/request/login_payload.dart';
import 'package:discover/models/users/request/register_payload.dart';
import 'package:discover/models/users/user.dart';
import 'package:discover/models/posts/posts_response.dart';
import 'package:discover/models/posts/request/posts_location_payload.dart';
import 'package:discover/utils/api/base_api.dart';
import 'package:geolocator/geolocator.dart';

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

  /// Get posts on map
  Future<PostsResponse> getPostsMaps(String token) async {
    final response = await httpGet(getUrl("/posts/map"), token: token);
    return PostsResponse.fromJson(getWithBaseData(response));
  }

  /// Get post
  Future<PostsResponse> getPost(int id, Position userPos, String token) async {
    final response = await httpGet(
      getUrl("/posts/$id", {
        'latitude_user': userPos.latitude.toString(),
        'longitude_user': userPos.longitude.toString(),
      }),
      token: token,
    );
    return PostsResponse.fromJson(getWithBaseData(response));
  }

  /// Add new post
  Future<PostsResponse> addPost(PostPayload payload, String token) async {
    final response = await httpPost(
      getUrl("/posts"),
      token: token,
      body: payload.toRawJson(),
    );
    return PostsResponse.fromJson(getWithBaseData(response));
  }

  /// Delete post
  Future<ResultResponse> deletePost(int postId, String token) async {
    final response = await httpDelete(getUrl("/posts/$postId"), token: token);
    return ResultResponse.fromJson(getWithBaseData(response));
  }

  /// Get tags
  Future<TagsResponse> getTags() async {
    final response = await httpGet(getUrl("/tags"));
    return TagsResponse.fromJson(getWithBaseData(response));
  }

  /// Get comment
  Future<CommentsResponse> getComments(int idPost, String token) async {
    final response = await httpGet(
      getUrl("/posts/$idPost/comments"),
      token: token,
    );
    return CommentsResponse.fromJson(getWithBaseData(response));
  }

  /// Add comment
  Future<ResultResponse> addComment(
    int idPost,
    CommentPayLoad payload,
    String token,
  ) async {
    final response = await httpPost(
      getUrl("/posts/$idPost/comments"),
      token: token,
      body: payload.toRawJson(),
    );
    return ResultResponse.fromJson(getWithBaseData(response));
  }

  /// Delete comment
  Future<ResultResponse> deleteComment(
    int postId,
    int commentId,
    String token,
  ) async {
    final response = await httpDelete(
      getUrl("/posts/$postId/comments/$commentId"),
      token: token,
    );
    return ResultResponse.fromJson(getWithBaseData(response));
  }

  /// Add like
  Future<ResultResponse> likePost(int idPost, String token) async {
    final res = await httpPost(getUrl("/posts/$idPost/likes"), token: token);
    return ResultResponse.fromJson(getWithBaseData(res));
  }
}
