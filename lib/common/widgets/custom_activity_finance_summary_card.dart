import 'package:flutter/material.dart';

class CustomActivityFinanceSummaryCard extends StatelessWidget {
  final String price;
  final String label;
  final String subtext;
  final IconData icon;
  final Color iconColor;
  final bool isUrgent;

  const CustomActivityFinanceSummaryCard({
    Key? key,
    required this.price,
    required this.label,
    required this.subtext,
    required this.icon,
    required this.iconColor,
    this.isUrgent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 12),
          Text(
            price,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff374151),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                subtext,
                style: TextStyle(
                  fontSize: 12,
                  color: subtext.contains('↓') ? Color(0xffEF4444) : Color(0xff6B7280),
                ),
              ),
              if (isUrgent)
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Urgent',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xffFF9500),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
