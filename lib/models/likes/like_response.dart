import 'dart:convert';

class LikeResponse {
   bool isLike;

   LikeResponse({
       this.isLike,
   });

   factory LikeResponse.fromRawJson(String str) => LikeResponse.fromJson(json.decode(str));

   String toRawJson() => json.encode(toJson());

   factory LikeResponse.fromJson(Map<String, dynamic> json) => new LikeResponse(
       isLike: json["is_like"],
   );

   Map<String, dynamic> toJson() => {
       "is_like": isLike,
   };
}