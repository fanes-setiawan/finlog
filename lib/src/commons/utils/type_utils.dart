// ignore_for_file: empty_catches

import 'dart:collection';
import 'dart:convert';

class TypeUtils {
  static double toDouble(dynamic obj, {double defaultValue = 0}) {
    if (obj == null) {
      return defaultValue;
    }

    if (obj is double) {
      return obj;
    }

    if (obj is String) {
      return double.tryParse(obj) ?? defaultValue;
    }

    return double.tryParse('$obj') ?? defaultValue;
  }

  static int toInt(dynamic obj, {int defaultValue = 0}) {
    if (obj == null) {
      return defaultValue;
    }

    if (obj is int) {
      return obj;
    }

    if (obj is String) {
      return int.tryParse(obj) ?? defaultValue;
    }

    return int.tryParse('$obj') ?? defaultValue;
  }

  static String toStr(dynamic obj, {String defaultValue = ''}) {
    if (obj == null) {
      return defaultValue;
    }

    if (obj is String) {
      return obj;
    }

    return '$obj';
  }

  static int countCharacter(String text, String charToCount) {
    int count = 0;
    for (int i = 0; i < text.length; i++) {
      if (text[i] == charToCount) {
        count++;
      }
    }
    return count;
  }

  static bool isEmpty(dynamic input) {
    return input == null ||
        (input is String && input.trim().isEmpty) ||
        (input is List && input.isEmpty) ||
        (input is Map<dynamic, dynamic> && input.isEmpty);
  }

  static bool mapEquals(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    if (map1.keys.length != map2.keys.length) return false;

    for (String k in map1.keys) {
      if (!map2.containsKey(k)) return false;
      if (map1[k] != map2[k]) return false;
    }

    return true;
  }

  static String generateTerbilang(double nominal) {
    if (nominal == 0) {
      return 'nol rupiah';
    }

    List<String> satuan = ['', 'satu', 'dua', 'tiga', 'empat', 'lima', 'enam', 'tujuh', 'delapan', 'sembilan'];
    List<String> belasan = [
      '',
      'sebelas',
      'dua belas',
      'tiga belas',
      'empat belas',
      'lima belas',
      'enam belas',
      'tujuh belas',
      'delapan belas',
      'sembilan belas'
    ];

    String result = '';

    // Triliun
    if (nominal >= 1e12) {
      int triliun = (nominal / 1e12).floor();
      result += '${generateTerbilang(triliun.toDouble())} triliun ';
      nominal %= 1e12;
    }

    // Miliar
    if (nominal >= 1e9) {
      int miliar = (nominal / 1e9).floor();
      result += '${generateTerbilang(miliar.toDouble())} miliar ';
      nominal %= 1e9;
    }

    // Juta
    if (nominal >= 1e6) {
      int juta = (nominal / 1e6).floor();
      result += '${generateTerbilang(juta.toDouble())} juta ';
      nominal %= 1e6;
    }

    // Ribu
    if (nominal >= 1000) {
      int ribu = (nominal / 1000).floor();
      result += '${generateTerbilang(ribu.toDouble())} ribu ';
      nominal %= 1000;
    }

    // Ratusan
    if (nominal >= 100) {
      int ratusan = (nominal / 100).floor();
      result += '${satuan[ratusan]} ratus ';
      nominal %= 100;
    }

    // Belasan atau puluhan
    if (nominal >= 11 && nominal <= 19) {
      result += '${belasan[nominal.toInt() - 10]} ';
      nominal = 0;
    } else if (nominal >= 20) {
      int puluhan = (nominal / 10).floor();
      result += '${satuan[puluhan]} puluh ';
      nominal %= 10;
    }

    // Satuan
    if (nominal > 0) {
      result += '${satuan[nominal.toInt()]} ';
    }

    // Desimal
    int desimal = ((nominal * 100) % 100).toInt();
    if (desimal > 0) {
      result += 'koma ';
      if (desimal >= 11 && desimal <= 19) {
        result += '${belasan[desimal - 10]} ';
      } else if (desimal >= 20) {
        int puluhan = (desimal / 10).floor();
        result += '${satuan[puluhan]} puluh ';
        desimal %= 10;
      }
      if (desimal > 0) {
        result += '${satuan[desimal]} ';
      }
    }

    return '${result.trim()}rupiah';
  }
}

extension StringUtilExt on String {
  String convertToCode() {
    if (isEmpty) return '';
    return trim().replaceAll(RegExp(r'\s+'), '-').toUpperCase();
  }

  String convertToCodeDocument() {
    if (isEmpty) return '';
    return trim().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').substring(0, 4).toUpperCase();
  }

  String kebabToCamel() {
    if (isEmpty) return '';
    return replaceAllMapped(RegExp(r'-.'), (match) => match.group(1)!.toUpperCase());
  }

  String camelToKebab() {
    if (isEmpty) return '';
    return replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) => '${match.group(1)}-${match.group(2)!}').toLowerCase();
  }

  String toTitleCase() {
    if (isEmpty) return '';
    return replaceAllMapped(RegExp(r'\w\S*'), (match) {
      return match.group(0)!.substring(0, 1).toUpperCase() + match.group(0)!.substring(1).toLowerCase();
    });
  }

  String pascalToTitleCase() {
    if (isEmpty) return '';

    final words = split(RegExp(r'(?=[A-Z])'));
    final titleCase = words.map((word) => '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}');

    return titleCase.join(' ');
  }

  String toCamelize() {
    if (isEmpty) return '';
    bool validate(String name) => !RegExp(r'[\s_-]').hasMatch(name) && name[0] == name[0].toLowerCase();
    if (validate(this)) return this;
    return toLowerCase().replaceAllMapped(RegExp(r'[^a-zA-Z0-9]+(.)'), (match) => match.group(1)!.toUpperCase());
  }

  String snakeToTitleCase() {
    if (isEmpty) return '';
    return toCamelize().pascalToTitleCase();
  }

  String toAB() {
    List<String> words = split(' ');
    String abbreviation = '';

    for (var word in words) {
      if (word.isNotEmpty) {
        abbreviation += word[0];
      }
    }

    return abbreviation.length > 2 ? abbreviation.substring(0, 2) : abbreviation;
  }

  String compressText({int maxLength = 26}) {
    String compressedText = '';

    if (length > maxLength) {
      // Remove vowels from the rest of the word
      compressedText = replaceAll(RegExp('[aeiouAEIOU]'), '');

      if (compressedText.length > maxLength) {
        compressedText = compressedText.substring(0, maxLength);
      }
    } else {
      compressedText = this;
    }

    return compressedText;
  }

  String lpadChar({String char = ' ', int maxLength = 5}) {
    if (isEmpty) return this;

    int chars = (maxLength) - length;
    if (chars <= 0) return this;

    return '${(char) * chars}$this';
  }

  String rpadChar({String char = ' ', int maxLength = 5}) {
    if (isEmpty) return this;

    int chars = (maxLength) - length;
    if (chars <= 0) return this;

    return '$this${(char) * chars}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = jsonDecode(this);
    return map;
  }
}

class DartTerbilang {
  late Map<String, String> digits;
  late Map<String, String> orders;
  late String? num;
  late String? result;
  late Type clazz;

  DartTerbilang() : this.fromNum(null);

  DartTerbilang.fromNum(Object? num) {
    digits = HashMap<String, String>();
    orders = HashMap<String, String>();
    clazz = Object;

    digits["0"] = "nol";
    digits["1"] = "satu";
    digits["2"] = "dua";
    digits["3"] = "tiga";
    digits["4"] = "empat";
    digits["5"] = "lima";
    digits["6"] = "enam";
    digits["7"] = "tujuh";
    digits["8"] = "delapan";
    digits["9"] = "sembilan";

    orders["0"] = "";
    orders["1"] = "puluh";
    orders["2"] = "ratus";
    orders["3"] = "ribu";
    orders["6"] = "juta";
    orders["9"] = "miliar";
    orders["12"] = "triliun";
    orders["15"] = "kuadriliun";

    this.num = convertNumToString(num);
  }

  void init() {
    bool isNeg = false;
    if (clazz == double) {
      double chk = double.parse(num!);
      isNeg = chk < 0;
    } else {
      isNeg = num!.startsWith("-") ? true : false;
    }
    String ints = "";
    try {
      RegExp regex = RegExp(r"^[+-]?(\d+)");
      Match regexMatch = regex.firstMatch(num!)!;
      ints = regexMatch.group(1)!;
    } catch (ex) {}
    int mult = 0;
    String wint = "";
    while (ints.isNotEmpty) {
      try {
        RegExp regex = RegExp(r"(\d{1,3})$");
        Match regexMatch = regex.firstMatch(ints)!;
        int m = int.parse(regexMatch.group(0)!);
        int s = (m % 10);
        int p = ((m % 100 - s) ~/ 10);
        int r = ((m - p * 10 - s) ~/ 100);

        String g = "";
        if (r == 0) {
          g = "";
        } else if (r == 1) {
          g = "se${orders["2"]!}";
        } else {
          g = "${digits["$r"]!} ${orders["2"]!}";
        }

        if (p == 0) {
          if (s == 0) {
          } else if (s == 1) {
            g = (g.isNotEmpty ? ("$g ${digits["$s"]!}").toString() : (mult == 0 ? digits["1"]!.toString() : "se"));
          } else {
            g = (g.isNotEmpty ? "$g " : "") + digits["$s"]!.toString();
          }
        } else if (p == 1) {
          if (s == 0) {
            g = "${g.isNotEmpty ? "$g " : ""}se${orders["1"]!}";
          } else if (s == 1) {
            g = "${g.isNotEmpty ? "$g " : ""}sebelas";
          } else {
            g = "${g.isNotEmpty ? "$g " : ""}${digits["$s"]!} belas";
          }
        } else {
          g = "${g.isNotEmpty ? "$g " : ""}${digits["$p"]!} puluh${s > 0 ? " ${digits["$s"]!}" : ""}";
        }

        wint =
            (g.isNotEmpty ? (g + (g == "se" ? "" : " ") + orders["$mult"]!) : "") + (wint.isNotEmpty ? " $wint" : "");

        String resultString = "";
        try {
          RegExp tsRegex = RegExp(r"\d{1,3}$");
          Match regexMatches = tsRegex.firstMatch(ints)!;
          resultString = regexMatches.group(0)!;
          ints = resultString;
        } catch (ex) {}
        mult += 3;
      } catch (ex) {}
    }
    if (wint.isEmpty) {
      wint = digits["0"]!;
    }

    String frac = "";
    try {
      RegExp regexf = RegExp(r"\.(\d+)");
      Match regexMatcherf = regexf.firstMatch(num!)!;
      frac = regexMatcherf.group(0)!;
    } catch (ex) {}
    String wfrac = "";
    for (int i = 0; i < frac.length; i++) {
      String indexf = frac[i];
      if (digits.containsKey(indexf)) {
        wfrac += (wfrac.isNotEmpty ? " " : "") + digits[indexf]!;
      }
    }

    result = ((isNeg ? "minus " : "") + wint + ((wfrac.isNotEmpty) ? " koma $wfrac" : ""));
    result = result!.replaceAll(RegExp(r'\s{2,}'), ' ');
    result = result!.replaceAll(RegExp(r'(null )|(\s{1,}$)'), '');
  }

  String? getNum() {
    return num;
  }

  void setNum(Object? num) {
    this.num = convertNumToString(num);
  }

  String? getResult() {
    return result;
  }

  @override
  String toString() {
    init();
    return "${getResult()!} rupiah";
  }

  String convertNumToString(Object? value) {
    if (clazz == String || clazz == double || clazz == int) {
      return value.toString();
    } else {
      return value.toString();
    }
  }
}
