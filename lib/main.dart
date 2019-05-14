import 'package:discover/app.dart';
import 'package:discover/utils/translations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Init translations
  await i18n.init();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  return runApp(App(prefs: prefs));
}
