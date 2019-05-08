import 'dart:convert';

class ResultResponse {
  bool result;

  ResultResponse({this.result});

  factory ResultResponse.fromRawJson(String str) =>
      ResultResponse.fromJson(json.decode(str));

  factory ResultResponse.fromJson(Map<String, dynamic> json) =>
      ResultResponse(result: json["result"]);
}
