import 'dart:convert';

class Tag {
  int id;
  String name;

  Tag({this.id, this.name});

  factory Tag.fromRawJson(String str) => Tag.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(id: json["id_tag"], name: json["nom_tag"]);

  Map<String, dynamic> toJson() => {"id_tag": id, "nom_tag": name};
}
