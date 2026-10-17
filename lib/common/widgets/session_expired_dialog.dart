import 'package:flutter/material.dart';

/// Blocking prompt telling the user they must log in again.
/// It can't be dismissed by tapping outside or pressing back.
class SessionExpiredDialog extends StatelessWidget {
  const SessionExpiredDialog({super.key, required this.message});

  final String message;

  static Future<void> show(BuildContext context, {required String message}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SessionExpiredDialog(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.lock_clock, color: Color(0xFF7C70DF)),
            SizedBox(width: 8),
            Text(
              'Session Expired',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff0F2D62),
              ),
            ),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 14)),
        actions: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff7C70DF), Color(0xffA198FF)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
