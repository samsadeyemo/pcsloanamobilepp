import 'package:flutter/material.dart';

class GradientIconActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double size;
  final IconData? icon; // 1. Added icon parameter

  const GradientIconActionButton({
    required this.text,
    required this.onPressed,
    required this.size,
    this.icon, // 2. Added to constructor (optional)
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff7C70DF), Color(0xffA198FF)],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Container(
            alignment: Alignment.center,
            // 3. Changed child to a Row to hold Icon and Text
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centers content
              mainAxisSize: MainAxisSize.min, // Wraps content tightly
              children: [
                // 4. Conditionally render the icon if it exists
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: Colors.white,
                    size: size * 1.2, // Slightly larger than text looks better
                  ),
                  const SizedBox(width: 8), // Spacing between icon and text
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}