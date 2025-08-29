import 'package:flutter/material.dart';

class CustomActivityFinanceCard extends StatelessWidget {
  final double totalInflow;      // e.g. 80000
  final double percentageChange; // e.g. 15.2

  const CustomActivityFinanceCard({
    super.key,
    required this.totalInflow,
    this.percentageChange = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF9C8FFF), // purple background
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE5E7EB),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon in rounded square
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.22),
                    ),
                  ),
                  child: const Icon(
                    Icons.show_chart,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                // Center text
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Inflows",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.85),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₦${totalInflow.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "This month",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const SizedBox(width: 56),
              ],
            ),
          ),

          // Percentage badge
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.22),
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    percentageChange >= 0
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 14,
                    color: percentageChange >= 0
                        ? const Color(0xFFFFFFFF) // green
                        : Colors.redAccent,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
