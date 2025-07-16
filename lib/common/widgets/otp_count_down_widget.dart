import 'dart:async';
import 'package:flutter/material.dart';

class OtpCountdown extends StatefulWidget {
  const OtpCountdown({
    super.key,
    this.totalSeconds = 180,              
    this.onExpired,
  });

  final int totalSeconds;

  final VoidCallback? onExpired;

  @override
  State<OtpCountdown> createState() => _OtpCountdownState();
}

class _OtpCountdownState extends State<OtpCountdown> {
  late int _secondsLeft;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.totalSeconds;

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft == 0) {
        _ticker!.cancel();
        widget.onExpired?.call();
      } else {
        setState(() => _secondsLeft--);
      }
    });
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