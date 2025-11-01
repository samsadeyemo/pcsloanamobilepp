import 'package:flutter/material.dart';

class MonthButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const MonthButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff7C70DF) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '$label Months',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
