import 'package:discover/models/base_response.dart';
import 'package:discover/models/custom_error.dart';
import 'package:http/http.dart' as http;

abstract class BaseApi {
  String apiUrl;

  BaseApi(this.apiUrl) {
    if (apiUrl.endsWith('/')) {
      apiUrl = apiUrl.substring(0, apiUrl.length - 1);
    }
  }

  String getUrl(String path, [Map<String, String> params]) {
    return "$apiUrl$path${_encodeParams(params)}";
  }

  Future<Map<String, String>> header([String token]) async {
    Map<String, String> header = {
      'Accept-Language': 'en',
      'Content-Type': 'application/json',
    };
    if (token != null) header['Authorization'] = token;
    return header;
  }

  Future<http.Response> httpPost(
    String url, {
    String body,
    String token,
  }) async {
    return await _doRequest(
      http.post(url, body: body, headers: await header(token)),
    );
  }

  Future<http.Response> httpDelete(String url, {String token}) async {
    return await _doRequest(http.delete(url, headers: await header(token)));
  }

  Future<http.Response> httpGet(String url, {String token}) async {
    return await _doRequest(http.get(url, headers: await header(token)));
  }

  /// Wrap an http request to handle server connection error or internet issue
  Future<http.Response> _doRequest(Future<http.Response> httpRequest) async {
    try {
      return await httpRequest;
    } catch (_) {
      throw CustomError("Error server response");
    }
  }

  Map<String, dynamic> getWithBaseData(http.Response response) {
    if (response.statusCode == 404) {
      throw CustomError("Unknown API Route");
    }
    CustomError error;
    try {
      BaseResponse baseRes = BaseResponse.fromRawJson(response.body);
      if (baseRes.error == null) return baseRes.data;
      error = baseRes.error;
    } catch (_) {}
    throw error ?? CustomError("Unknown error");
  }

  String _encodeParams(Map<String, String> params) {
    if (params == null) return "";
    List<String> queries = params.keys.map((key) {
      return "${Uri.encodeComponent(key)}=${Uri.encodeComponent(params[key])}";
    }).toList();
    if (queries.length == 0) return "";
    return "?${queries.join('&')}";
  }
}
