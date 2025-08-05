import 'package:flutter/material.dart';

class CircleTextBadge extends StatelessWidget {
  final String text;

  const CircleTextBadge({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xffA198FF).withOpacity(0.1),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xff7C70DF),
            fontSize: 17,
            fontWeight: FontWeight.bold,
            fontFamily: "Inter",
          ),
        ),
      ),
    );
  }
}
