import 'package:flutter/material.dart';

enum LocaleLanguage {
  en('en'),
  tr('tr');

  const LocaleLanguage(this.value);

  factory LocaleLanguage.fromString(String value) =>
      LocaleLanguage.values.firstWhere((e) => e.value == value);

  final String value;
}

extension LocaleExtensions on BuildContext {
  List<Locale> get supportedCoreLocales => [
    Locale(LocaleLanguage.en.value),
    Locale(LocaleLanguage.tr.value),
  ];

  Locale get currentLocale => Localizations.localeOf(this);

  bool get isLocaleEn => currentLocale.languageCode == LocaleLanguage.en.value;
  bool get isLocaleTr => currentLocale.languageCode == LocaleLanguage.tr.value;

  LocaleLanguage get currentLocaleLanguage =>
      LocaleLanguage.fromString(currentLocale.languageCode);

  Locale get localeEn => Locale(LocaleLanguage.en.value);
  Locale get localeTr => Locale(LocaleLanguage.tr.value);
}
