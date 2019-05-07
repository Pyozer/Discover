import 'dart:convert';

import 'package:geolocator/geolocator.dart';

String positionToJsonString(Position position) {
  if (position == null) return null;
  return json.encode(<String, double>{
    'latitude': position.latitude,
    'longitude': position.longitude,
  });
}

Position stringToPosition(String jsonStr) {
  if (jsonStr == null) return null;
  Map<String, double> jsonMap = json.decode(jsonStr);
  return Position(
    latitude: jsonMap['latitude'],
    longitude: jsonMap['longitude'],
  );
}

bool isEmail(String email) {
  final emailText = email?.trim()?.toLowerCase() ?? "";
  if (emailText.length < 5) return false; // Minimum length 5: "a@b.c"
  final regex = RegExp(
    r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$",
  );
  return regex.hasMatch(emailText);
}

String getTimeAgo(DateTime time) {
  if (time == null) return "";

  final diff = DateTime.now().difference(time);
  if (diff.inSeconds < 60) return "${diff.inSeconds} sec ago";
  if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";

  final hours = diff.inHours;
  if (hours < 60) return "$hours hour${hours > 1 ? "s" : ""} ago";

  final days = diff.inDays;
  if (days < 30) return "$days day${days > 1 ? "s" : ""} ago";

  final mounths = diff.inDays / 30;
  if (days < 365) return "$mounths mounth${mounths > 1 ? "s" : ""} ago";

  final years = diff.inDays ~/ 365;
  return "$years year${years > 1 ? "s" : ""} ago";
}

String getDistance(double distance) {
  if (distance == null) return "";
  return distance < 1000 ? "$distance m" : "${distance ~/ 1000} km";
}
