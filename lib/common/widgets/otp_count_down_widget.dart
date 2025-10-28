// otp_count_down_widget.dart
import 'dart:async';
import 'package:flutter/material.dart';

class OtpCountdown extends StatefulWidget {
  const OtpCountdown({
    super.key,
    this.totalSeconds = 300, // 5 minutes
    this.onExpired,
  });

  final int totalSeconds;
  final VoidCallback? onExpired;

  @override
  State<OtpCountdown> createState() => OtpCountdownState();
}

/// Public state so parent can hold a GlobalKey<OtpCountdownState> and call reset()
class OtpCountdownState extends State<OtpCountdown> {
  late int _secondsLeft;
  Timer? _ticker;

  void _startTimer() {
    _ticker?.cancel();
    _secondsLeft = widget.totalSeconds;

    // Tick every second
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_secondsLeft <= 0) {
        _ticker?.cancel();
        widget.onExpired?.call();
        setState(() {}); // ensure UI updates to show 00:00 if needed
      } else {
        setState(() => _secondsLeft--);
      }
    });
    setState(() {});
  }

  /// Call this to restart the countdown from widget.totalSeconds
  void reset() {
    _startTimer();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');

    return Text(
      '$minutes:$seconds',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xffA198FF),
      ),
    );
  }
}
