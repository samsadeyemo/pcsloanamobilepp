import 'package:flutter/material.dart';
import 'package:pcsloan/features/activity/data/transaction_model.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailsScreen({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${transaction.title}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Date & Time: ${transaction.dateTime}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Amount: ${transaction.amount}', style: TextStyle(
              fontSize: 16,
              color: transaction.isCredit ? Colors.green : Colors.red,
            )),
            const SizedBox(height: 10),
            Text('Type: ${transaction.isCredit ? 'Credit' : 'Debit'}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
