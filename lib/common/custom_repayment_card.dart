import 'package:flutter/material.dart';

class RepaymentScheduleCard extends StatelessWidget {
  final List schedulePreview;

  const RepaymentScheduleCard({
    Key? key,
    required this.schedulePreview,
  }) : super(key: key);

  String _getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) {
      return 'th';
    }
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _formatAmount(dynamic amount) {
    return '₦${amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Color(0xffF9FAFB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: Color(0xff6B7280),
                ),
                SizedBox(width: 8),
                Text(
                  'Repayment Schedule',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff1F2937),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Repayment items
            ...schedulePreview.asMap().entries.map((entry) {
              final index = entry.key;
              final schedule = entry.value;
              final isLast = index == schedulePreview.length - 1;

              return Container(
                margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Left side - Month indicator
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '${schedule['month']}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff4F46E5),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    
                    // Middle - Repayment info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${schedule['month']}${_getOrdinalSuffix(schedule['month'])} Repayment',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff1F2937),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _formatDate(schedule['paymentDate']),
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xff6B7280),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Right side - Amount
                    Text(
                      _formatAmount(schedule['amount']),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff1F2937),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// Usage example:
// RepaymentScheduleCard(
//   schedulePreview: [
//     {'month': 1, 'amount': 62500, 'paymentDate': '2025-12-10'},
//     {'month': 2, 'amount': 62500, 'paymentDate': '2026-01-10'},
//     // ... more items
//   ],
// )