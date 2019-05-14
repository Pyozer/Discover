import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:discover/utils/keys/string_key.dart';
import 'package:flutter/services.dart';
import 'package:devicelocale/devicelocale.dart';

///
/// Preferences related
///
const Map<String, String> _supportedLanguages = {
  'en': 'eng',
  'fr': 'fra',
};
const Locale kDefaultLocale = Locale('en', 'UK');

class GlobalTranslations {
  Locale _locale;
  Map<String, dynamic> _localizedValues;

  ///
  /// Returns the list of supported Locales
  ///
  Iterable<Locale> supportedLocales() {
    return _supportedLanguages.keys.map((lang) => Locale(lang));
  }

  ///
  /// Returns if language is supported
  ///
  bool _isSupported(Locale locale) {
    for (final lang in _supportedLanguages.keys) {
      if (lang == locale?.languageCode?.toLowerCase() ||
          lang == locale?.countryCode?.toLowerCase()) return true;
    }
    return false;
  }

  Locale stringToLocale(String text) {
    if (text == null || text.isEmpty) return null;
    final localValues = text.split(text.contains('-') ? '-' : '_');
    return Locale(localValues[0], localValues.length > 1 ? localValues[1] : null);
  }

  Future<Locale> getDeviceSupportedLocale() async {
    // Check if current locale is supported
    Locale currLocale = stringToLocale(await Devicelocale.currentLocale);
    if (currLocale != null && _isSupported(currLocale)) {
      return currLocale;
    }

    // Check if preferred languages are supported
    final preferedLocales = (await Devicelocale.preferredLanguages)
        .map((l) => stringToLocale(l.toString()));
    for (final locale in preferedLocales) {
      if (_isSupported(locale)) return locale;
    }
    // Otherwise return default locale
    return kDefaultLocale;
  }

  ///
  /// Returns the translation that corresponds to the [key]
  ///
  String text(StrKey key, [Map<String, dynamic> params]) {
    // Return the requested string
    final keyStr = key.toString();
    String text = (_localizedValues == null || _localizedValues[keyStr] == null)
        ? '** $keyStr not found'
        : _localizedValues[keyStr];

    if (params != null && params.isNotEmpty) {
      for (String paramKey in params.keys)
        text = text.replaceAll(
          RegExp('{$paramKey}'),
          params[paramKey].toString(),
        );
    }
    return text;
  }

  ///
  /// Returns the current language code
  ///
  String get currentLanguage =>
      _locale?.languageCode ?? kDefaultLocale.languageCode;

  ///
  /// Returns the current language code in ISO639_1 (ex: eng)
  ///
  String get langCodeISO639_1 => _supportedLanguages[currentLanguage];

  ///
  /// Returns the current Locale
  ///
  Locale get locale => _locale ?? kDefaultLocale;

  ///
  /// Initialization
  ///
  Future<bool> init([Locale forceLocale]) async {
    Locale supportedLocal;
    if (forceLocale != null && _isSupported(forceLocale)) {
      supportedLocal = forceLocale;
    } else {
      supportedLocal = await getDeviceSupportedLocale();
    }

    if (_locale == null || _locale != supportedLocal) {
      await updateLanguage(supportedLocal);
      return true;
    }
    return false;
  }

  ///
  /// Change language
  ///
  Future<void> updateLanguage(Locale newLocale) async {
    _locale = newLocale;
    // Load the language strings
    String jsonContent = await rootBundle.loadString(
      "assets/translations/${_locale.languageCode}.json",
    );
    _localizedValues = json.decode(jsonContent);
    return;
  }

  ///
  /// Singleton Factory
  ///
  static final _translations = GlobalTranslations._internal();
  factory GlobalTranslations() => _translations;

  GlobalTranslations._internal();
}

GlobalTranslations i18n = GlobalTranslations();
