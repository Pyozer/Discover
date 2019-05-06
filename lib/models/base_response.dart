import 'dart:convert';

import 'package:discover/models/custom_error.dart';

class BaseResponse {
  bool isSuccess;
  Map<String, dynamic> data;
  String message;

  BaseResponse({this.isSuccess, this.data, this.message});

  CustomError get error => !isSuccess ? CustomError(this.message) : null;

  factory BaseResponse.fromRawJson(String str) =>
      BaseResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        isSuccess: json["status"] == "success",
        data: json["data"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": isSuccess ? "success" : "error",
        "data": data,
        "message": error,
      };
}
