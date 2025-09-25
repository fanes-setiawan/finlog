import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@singleton
class LocalClient {
  static const boxName = "finlog";

  late final Box _box;

  LocalClient() {
    _box = Hive.box(boxName);
  }

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  Future<void> set(String key, dynamic value) async {
    await _box.put(key, value);
  }

  dynamic get(String key, {dynamic defaultValue}) {
    return _box.get(key, defaultValue: defaultValue);
  }

  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
