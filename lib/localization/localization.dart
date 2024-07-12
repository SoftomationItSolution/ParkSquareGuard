import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoLocalizations {
  Locale locale;
  DemoLocalizations(this.locale);

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations)!;
  }

  Map<dynamic, dynamic>? _localizedValue;

  Map flattedValue(Map<dynamic, dynamic> json, [String prifix = '']) {
    Map<dynamic, dynamic> transaction = {};

    json.forEach((dynamic key, dynamic value) {
      if (value is Map) {
        transaction.addAll(flattedValue(value, '$prifix$key.'));
      } else {
        transaction['$prifix$key'] = value.toString();
      }
    });
    return transaction;
  }

  Future load() async {
    String jsonStringValue =
        await rootBundle.loadString('languages/${locale.languageCode}.json');

    Map mappedValue = json.decode(jsonStringValue);

    _localizedValue = flattedValue(mappedValue);
  }

  String getTranslation(String key) {
    return _localizedValue![key] ?? key;
  }

  static LocalizationsDelegate<DemoLocalizations> delegate =
      const DemoLocalizationsDelegate();

  static DemoLocalizations get instance => DemoLocalizationsDelegate.instance!;
}

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  static DemoLocalizations? instance;

  @override
  bool isSupported(Locale locale) =>
      ['en', 'hi', 'id', 'zh', 'ar'].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) async {
    DemoLocalizations localizations = DemoLocalizations(locale);
    await localizations.load();
    instance = localizations;
    return localizations;
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}
