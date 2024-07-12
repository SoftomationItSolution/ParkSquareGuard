import 'package:fl_sevengen_society_guard_app/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getTranslate(BuildContext context, String key) {
  return DemoLocalizations.of(context).getTranslation(key);
}

String translate(String key) {
  return DemoLocalizations.instance.getTranslation(key);
}

const String english = 'en';
const String hindi = 'hi';
const String indonesian = 'id';
const String chinese = 'zh';
const String arabic = 'ar';
const String languageKey = 'languageCode';

int? languageValue;

Future setIntLanguageValue(int languageValue) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setInt('value', languageValue);
}

Future getIntLanguageValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  languageValue = prefs.getInt('value') ?? 0;
}

Future setLocale(String languageCode) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.setString(languageKey, languageCode);
  return _locale(languageCode);
}

Future getLocale() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String languageCode = preferences.getString(languageKey) ?? english;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  Locale temp;
  switch (languageCode) {
    case english:
      temp = Locale(languageCode);
      break;
    case hindi:
      temp = Locale(languageCode);
      break;
    case indonesian:
      temp = Locale(languageCode);
      break;

    case chinese:
      temp = Locale(languageCode);
      break;
    case arabic:
      temp = Locale(languageCode);
      break;
    default:
      temp = const Locale(english);
  }
  return temp;
}
