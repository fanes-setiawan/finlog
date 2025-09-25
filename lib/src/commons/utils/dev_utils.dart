import 'package:finlog/src/commons/clients/local/local_client.dart';
import 'package:finlog/src/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

/// Development utilities for debugging and testing
class DevUtils {
  DevUtils._();

  /// Clear all local data (only available in development builds)
  static Future<void> clearAllData() async {
    // Only allow this in development builds
    if (FlavorConfig.instance.name == 'prod') {
      debugPrint('🔥 DevUtils: clearAllData() is not available in production');
      return;
    }

    try {
      debugPrint('🔥 DevUtils: Clearing all local data...');
      final localClient = getIt.get<LocalClient>();
      await localClient.clear();

      debugPrint('🔥 DevUtils: All local data cleared successfully');
    } catch (e) {
      debugPrint('🔥 DevUtils: Error clearing data: $e');
    }
  }

  /// Reset first installation flag (only available in development builds)
  static Future<void> resetFirstInstallation() async {
    // Only allow this in development builds
    if (FlavorConfig.instance.name == 'prod') {
      debugPrint(
          '🔥 DevUtils: resetFirstInstallation() is not available in production');
      return;
    }

    try {
      debugPrint('🔥 DevUtils: Resetting first installation flag...');

      final localClient = getIt.get<LocalClient>();
      await localClient.delete('isFirstInstallation');

      debugPrint('🔥 DevUtils: First installation flag reset successfully');
    } catch (e) {
      debugPrint('🔥 DevUtils: Error resetting first installation: $e');
    }
  }

  /// Check if current build is development
  static bool get isDevelopment => FlavorConfig.instance.name != 'prod';

  /// Get current flavor info
  static String get flavorInfo => 'Flavor: ${FlavorConfig.instance.name}';
}
