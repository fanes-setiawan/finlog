import 'package:finlog/src/commons/constants/styles/app_color.dart';
import 'package:finlog/src/commons/constants/styles/app_space.dart';
import 'package:finlog/src/commons/constants/styles/app_text.dart';
import 'package:finlog/src/commons/utils/dev_utils.dart';
import 'package:finlog/src/commons/widgets/primary_button.dart';
import 'package:flutter/material.dart';

/// Debug menu for development builds only
class DebugMenu extends StatelessWidget {
  const DebugMenu({super.key});

  static void show(BuildContext context) {
    if (!DevUtils.isDevelopment) return;

    showDialog(
      context: context,
      builder: (context) => const DebugMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!DevUtils.isDevelopment) {
      return const SizedBox.shrink();
    }

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.bug_report, color: AppColor.red500),
          const SizedBox(width: AppSpace.x2),
          Text('Debug Menu', style: AppText.l16SemiBold),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DevUtils.flavorInfo, style: AppText.l14Regular),
          const SizedBox(height: AppSpace.x4),
          _buildDebugAction(
            context,
            icon: Icons.delete_forever,
            title: 'Clear All Data',
            subtitle: 'Remove all stored user data and settings',
            onTap: () => _clearAllData(context),
          ),
          const SizedBox(height: AppSpace.x3),
          _buildDebugAction(
            context,
            icon: Icons.refresh,
            title: 'Reset First Installation',
            subtitle: 'Reset first installation flag',
            onTap: () => _resetFirstInstallation(context),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close', style: AppText.l14Regular),
        ),
      ],
    );
  }

  Widget _buildDebugAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpace.x2),
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.x2),
        child: Row(
          children: [
            Icon(icon, color: AppColor.orange500),
            const SizedBox(width: AppSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.l14SemiBold),
                  Text(subtitle,
                      style:
                          AppText.l12Regular.copyWith(color: AppColor.gray600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearAllData(BuildContext context) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: 'Clear All Data',
      message:
          'This will remove all stored user data, settings, and cached information. This action cannot be undone.',
    );

    if (confirmed) {
      Navigator.of(context).pop(); // Close debug menu
      await DevUtils.clearAllData();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data cleared successfully'),
            backgroundColor: AppColor.green500,
          ),
        );
      }
    }
  }

  void _resetFirstInstallation(BuildContext context) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: 'Reset First Installation',
      message:
          'This will reset the first installation flag, causing the app to show the language selection screen on next restart.',
    );

    if (confirmed) {
      Navigator.of(context).pop(); // Close debug menu
      await DevUtils.resetFirstInstallation();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('First installation flag reset'),
            backgroundColor: AppColor.green500,
          ),
        );
      }
    }
  }

  Future<bool> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: AppText.l16SemiBold),
        content: Text(message, style: AppText.l14Regular),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: AppText.l14Regular),
          ),
          PrimaryButton(
            label: 'Confirm',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
