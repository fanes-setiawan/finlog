import 'package:easy_localization/easy_localization.dart';
import 'package:finlog/src/commons/extensions/translate_extension.dart';
import 'package:flutter/material.dart';

extension AppDateTimeExtension on DateTime {
  String fromNow() {
    try {
      final now = DateTime.now();
      final difference = now.difference(this);

      // Jika kurang dari 1 menit
      if (difference.inSeconds < 60) {
        return 'sekarang'.trLabel();
      }
      // Kurang dari 1 jam
      else if (difference.inMinutes < 60) {
        final minutes = difference.inMinutes;
        return '$minutes menitYangLalu'.trLabel();
      }
      // Kurang dari 1 hari
      else if (difference.inHours < 24) {
        final hours = difference.inHours;
        return '$hours jamYangLalu'.trLabel();
      }
      // kurang dari 2 hari
      else if (difference.inDays == 1) {
        return 'kemarin'.trLabel();
      }
      // Kurang dari 7 hari
      else if (difference.inDays < 7) {
        final days = difference.inDays;
        return '$days hariYangLalu'.trLabel();
      }
      // Kurang dari 4 minggu
      else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks mingguYangLalu'.trLabel();
      }
      // Kurang dari 12 bulan
      else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '$months bulanYangLalu'.trLabel();
      }
      // Lebih dari atau sama dengan 1 tahun
      else {
        final years = (difference.inDays / 365).floor();
        return '$years tahunYangLalu'.trLabel();
      }
    } catch (_) {
      return "";
    }
  }

  String toDay() {
    final day = this.day;

    debugPrint('🔥 app_datetime_extension:7 ~ day:$day');

    switch (day) {
      case 1:
        return "sunday".trLabel();
      case 2:
        return "monday".trLabel();
      case 3:
        return "tuesday".trLabel();
      case 4:
        return "wednesday".trLabel();
      case 5:
        return "thursday".trLabel();
      case 6:
        return "friday".trLabel();
      case 7:
        return "saturday".trLabel();
      default:
        return "-".trLabel();
    }
  }

  String toDayReq() {
    // Map full day names to three-letter abbreviations
    const dayMap = {
      'Monday': 'MON',
      'Tuesday': 'TUE',
      'Wednesday': 'WED',
      'Thursday': 'THU',
      'Friday': 'FRI',
      'Saturday': 'SAT',
      'Sunday': 'SUN',
    };

    // Get full day name using DateFormat
    final String dayName = DateFormat('EEEE').format(this);
    return dayMap[dayName] ?? 'UNKNOWN'; // Return abbreviation or fallback
  }
}
