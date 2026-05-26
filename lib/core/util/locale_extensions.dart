import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum LocaleLanguage {
  en('en'),
  tr('tr'),
  es('es'),
  pt('pt'),
  fr('fr'),
  de('de'),
  it('it'),
  ja('ja'),
  ko('ko'),
  th('th'),
  zhTw('zh-TW'),
  ru('ru'),
  zhCn('zh-CN');

  const LocaleLanguage(this.value);

  factory LocaleLanguage.fromLocale(Locale locale) {
    final value = switch (locale.countryCode) {
      final countryCode? => '${locale.languageCode}-$countryCode',
      _ => locale.languageCode,
    };
    return LocaleLanguage.values.firstWhere((e) => e.value == value);
  }

  final String value;

  Locale get locale {
    final parts = value.split('-');
    return parts.length == 1
        ? Locale(parts.first)
        : Locale(parts.first, parts.last);
  }
}

extension LocaleExtensions on BuildContext {
  List<Locale> get supportedCoreLocales =>
      LocaleLanguage.values.map((e) => e.locale).toList();

  Locale get currentLocale => locale;

  bool get isLocaleEn => currentLocale.languageCode == LocaleLanguage.en.value;
  bool get isLocaleTr => currentLocale.languageCode == LocaleLanguage.tr.value;

  LocaleLanguage get currentLocaleLanguage =>
      LocaleLanguage.fromLocale(currentLocale);

  Locale get localeEn => LocaleLanguage.en.locale;
  Locale get localeTr => LocaleLanguage.tr.locale;
}
