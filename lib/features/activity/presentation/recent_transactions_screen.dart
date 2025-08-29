import 'package:flutter/material.dart';
import 'package:pcsloan/features/activity/data/transaction_model.dart';
import 'package:pcsloan/features/activity/presentation/transaction_detail_screen.dart';

class RecentTransactionsPage extends StatelessWidget {
  final List<Transaction> transactions = [
    Transaction(
      title: 'Loan Disbursement',
      dateTime: 'Today, 2:30 PM',
      amount: '+₦50,000.00',
      isCredit: true,
    ),
    Transaction(
      title: 'Monthly Repayment',
      dateTime: 'Yesterday, 10:15 AM',
      amount: '-₦20,000.00',
      isCredit: false,
    ),
    Transaction(
      title: 'Wallet Funding',
      dateTime: 'Apr 8, 4:00 PM',
      amount: '+₦30,000.00',
      isCredit: true,
    ),
    Transaction(
      title: 'Interest Charge',
      dateTime: 'Apr 7, 9:30 AM',
      amount: '-₦2,500.00',
      isCredit: false,
    ),
    Transaction(
      title: 'Fund Transfer',
      dateTime: 'Apr 6, 11:45 AM',
      amount: '+₦15,000.00',
      isCredit: true,
    ),
    Transaction(
      title: 'Loan Application Fee',
      dateTime: 'Apr 5, 11:25 AM',
      amount: '-₦1,000.00',
      isCredit: false,
    ),
    Transaction(
      title: 'Bank Transfer',
      dateTime: 'Apr 5, 11:15 AM',
      amount: '+₦10,000.00',
      isCredit: true,
    ),
    Transaction(
      title: 'Processing Fee',
      dateTime: 'Apr 5, 11:00 AM',
      amount: '-₦2,000.00',
      isCredit: false,
    ),
    Transaction(
      title: 'Mobile Top-up',
      dateTime: 'Apr 5, 10:45 AM',
      amount: '-₦1,500.00',
      isCredit: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recent Transactions',
          style: TextStyle(
            color: Color(0xff0F2D62),
            fontSize: 18,
            fontFamily: "Inter",
          ),
        ),
        backgroundColor: Color(0xffFFFFFF),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        actions: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xffA198FF).withOpacity(0.1),
            ),
            child: Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () {
                  // Handle icon tap
                  print('Notification icon tapped');
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      backgroundColor: Color(0xffFFFFFF),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransactionDetailsScreen(transaction: tx),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    tx.isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                    color: tx.isCredit ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tx.dateTime,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    tx.amount,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: tx.isCredit ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
