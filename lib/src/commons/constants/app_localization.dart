import 'package:flutter/material.dart';

class AppLocalization {
  AppLocalization._();

  static const supportedLocales = [
    localeId,
    localeEn,
  ];

  static const localeId = Locale('id', 'ID');
  static const localeEn = Locale('en', 'US');

  static const fallbackLocale = localeId;

  static const startLocale = localeEn;

  static const path = "assets/translations";
}
