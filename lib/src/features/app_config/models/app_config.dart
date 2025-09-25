import 'package:finlog/src/commons/constants/app_localization.dart';
import 'package:flutter/material.dart';

class AppConfig {
  final String currCode;
  final Locale locale;
  final String version;
  final int maxDigitCurr;
  final int maxDigitQty;
  final String currLocale;
  final bool? loadConfig;
  final String macAddressBle;
  final String printerNameBle;
  final String typePrinter;
  final String defaultPrintFooter;
  final String kelolaBisnisWebUrl;
  final int countTrxAds;
  final int countReportAds;

  AppConfig({
    this.currCode = '',
    this.locale = AppLocalization.startLocale,
    this.version = 'Unknown',
    this.maxDigitCurr = 2,
    this.maxDigitQty = 3,
    this.loadConfig,
    this.currLocale = '',
    this.macAddressBle = '',
    this.printerNameBle = '',
    this.typePrinter = '',
    this.defaultPrintFooter = 'Powered by Kelola Bisnis',
    this.countTrxAds = 10,
    this.countReportAds = 10,
    this.kelolaBisnisWebUrl = '',
  });

  AppConfig copyWith({
    String? currCode,
    Locale? locale,
    String? version,
    int? maxDigitCurr,
    int? maxDigitQty,
    String? currLocale,
    bool? loadConfig,
    String? macAddressBle,
    String? printerNameBle,
    String? typePrinter,
    String? defaultPrintFooter,
    int? countTrxAds,
    int? countReportAds,
    String? kelolaBisnisWebUrl,
  }) {
    return AppConfig(
      currCode: currCode ?? this.currCode,
      locale: locale ?? this.locale,
      version: version ?? this.version,
      maxDigitCurr: maxDigitCurr ?? this.maxDigitCurr,
      maxDigitQty: maxDigitQty ?? this.maxDigitQty,
      loadConfig: loadConfig ?? this.loadConfig,
      currLocale: currLocale ?? this.currLocale, macAddressBle: macAddressBle ?? this.macAddressBle,
      printerNameBle: printerNameBle ?? this.printerNameBle,
      typePrinter: typePrinter ?? this.typePrinter,
      defaultPrintFooter: defaultPrintFooter ?? this.defaultPrintFooter,
      countTrxAds: countTrxAds ?? this.countTrxAds,
      countReportAds: countReportAds ?? this.countReportAds,
      kelolaBisnisWebUrl: kelolaBisnisWebUrl ?? this.kelolaBisnisWebUrl,
    );
  }
}
