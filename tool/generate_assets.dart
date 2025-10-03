import 'dart:io';

void main() {
  final buffer = StringBuffer();
  buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND");
  buffer.writeln("// ignore_for_file: constant_identifier_names\n");
  buffer.writeln("class AppAssets {");

  // ========== ICONS ==========
  buffer.writeln("  // ----------------- ICONS -----------------");
  _generateForDir("assets/icons", buffer);

  // ========== IMAGES ==========
  buffer.writeln("\n  // ----------------- IMAGES -----------------");
  _generateForDir("assets/images", buffer);

  // ========== LOGO ==========
  buffer.writeln("\n  // ----------------- LOGO -----------------");
  _generateForDir("assets/logo", buffer);

  buffer.writeln("}");

  File("lib/src/commons/constants/app_assets.dart")
      .writeAsStringSync(buffer.toString());

  print("✅ Berhasil generate lib/src/commons/constants/app_assets.dart");
}

void _generateForDir(String path, StringBuffer buffer) {
  final dir = Directory(path);
  if (!dir.existsSync()) return;

  for (var file in dir.listSync()) {
    if (file is File) {
      final fileName = file.uri.pathSegments.last;
      final baseName = fileName.split(".").first;
      final varName = _toCamelCase(baseName);
      buffer.writeln(
          "  static const String ${varName} = '$path/$fileName';");
    }
  }
}

String _toCamelCase(String input) {
  final parts = input.split(RegExp(r'[-_]'));
  return parts.first +
      parts.skip(1).map((w) => w[0].toUpperCase() + w.substring(1)).join();
}
