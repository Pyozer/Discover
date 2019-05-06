import 'dart:convert';

class Tag {
    int idTag;
    String nomTag;

    Tag({
        this.idTag,
        this.nomTag,
    });

    factory Tag.fromRawJson(String str) => Tag.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Tag.fromJson(Map<String, dynamic> json) => new Tag(
        idTag: json["id_tag"],
        nomTag: json["nom_tag"],
    );

    Map<String, dynamic> toJson() => {
        "id_tag": idTag,
        "nom_tag": nomTag,
    };
}