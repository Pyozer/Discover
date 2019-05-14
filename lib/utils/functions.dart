import 'dart:convert';

import 'package:discover/utils/keys/string_key.dart';
import 'package:discover/utils/translations.dart';
import 'package:discover/widgets/ui/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

String positionToJsonString(Position position) {
  if (position == null) return null;
  return json.encode(<String, dynamic>{
    'latitude': position.latitude,
    'longitude': position.longitude,
  });
}

Position stringToPosition(String jsonStr) {
  if (jsonStr == null) return null;
  Map<String, dynamic> jsonMap = json.decode(jsonStr);
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
  if (diff.inSeconds < 60)
    return i18n.text(StrKey.secAgo, {'sec': diff.inSeconds});
  if (diff.inMinutes < 60)
    return i18n.text(
      diff.inMinutes > 1 ? StrKey.minsAgo : StrKey.minAgo,
      {'min': diff.inMinutes},
    );

  final hours = diff.inHours;
  if (hours < 24)
    return i18n.text(
      hours > 1 ? StrKey.hoursAgo : StrKey.hourAgo,
      {'hour': hours},
    );

  final days = diff.inDays;
  if (days < 30)
    return i18n.text(days > 1 ? StrKey.daysAgo : StrKey.dayAgo, {'day': days});

  final mounths = diff.inDays / 30;
  if (days < 365)
    return i18n.text(
      mounths > 1 ? StrKey.monthsAgo : StrKey.monthAgo,
      {'month': mounths},
    );

  final years = diff.inDays ~/ 365;
  return i18n.text(StrKey.yearAgo, {'year': years});
}

String getDistance(int distance) {
  if (distance == null) return "";
  return distance < 1000 ? "${distance}m" : "${distance ~/ 1000}km";
}

void showErrorDialog(BuildContext context, dynamic error) {
  if (context == null) return;
  showDialog(
    context: context,
    builder: (dialogCtx) {
      return CustomAlertDialog(
        title: i18n.text(StrKey.error),
        content: Text(error.toString()),
        isNegative: false,
        positiveBtn: i18n.text(StrKey.ok),
        onPositive: () => Navigator.of(dialogCtx).pop(),
      );
    },
  );
}
