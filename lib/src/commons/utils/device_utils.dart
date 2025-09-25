import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceUtils {

  static Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = "";

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id; // Unique device ID
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? ""; // Unique ID for iOS
    }

    return deviceId;
  }

  static String getPlatform() {
    if (Platform.isAndroid) return "android";
    if (Platform.isIOS) return "ios";
    if (Platform.isLinux) return "linux";
    if (Platform.isMacOS) return "macos";
    if (Platform.isWindows) return "windows";
    return "unknown";
  }
}
