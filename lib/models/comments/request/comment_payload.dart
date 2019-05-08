import 'dart:convert';

class CommentPayLoad {
  String text;


  CommentPayLoad({
    this.text,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "text_comment": text,
      };
}
