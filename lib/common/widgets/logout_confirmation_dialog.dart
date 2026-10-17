import 'package:flutter/material.dart';

/// Asks the user to confirm logging out.
///
/// Usage:
/// ```dart
/// if (await LogoutConfirmationDialog.show(context)) { ...logout... }
/// ```
class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  /// Shows the dialog and resolves to `true` only if the user taps Logout.
  static Future<bool> show(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const LogoutConfirmationDialog(),
    );
    return confirmed ?? false; // dismissed by tapping outside / back button
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.exit_to_app, color: Colors.red),
          SizedBox(width: 8),
          Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
      content: const Text(
        'Are you sure you want to logout? You will need to login with your password again.',
        style: TextStyle(fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF7C70DF)),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
