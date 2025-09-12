// import 'package:flutter/material.dart';
// import 'package:pcsloan/features/activity/data/transaction_model.dart';

// class TransactionDetailsScreen extends StatelessWidget {
//   final Transaction transaction;

//   const TransactionDetailsScreen({Key? key, required this.transaction}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Transaction Details')),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Title: ${transaction.title}', style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 10),
//             Text('Date & Time: ${transaction.dateTime}', style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text('Amount: ${transaction.amount}', style: TextStyle(
//               fontSize: 16,
//               color: transaction.isCredit ? Colors.green : Colors.red,
//             )),
//             const SizedBox(height: 10),
//             Text('Type: ${transaction.isCredit ? 'Credit' : 'Debit'}', style: const TextStyle(fontSize: 16)),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pcsloan/features/activity/data/transaction_model.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailsScreen({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          
        ),
         surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Success Icon & Amount
            Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: transaction.isCredit ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  child:  Icon(
                    transaction.isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                    color: transaction.isCredit ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Success", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(
                  transaction.amount,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                 Text(transaction.title),
              ],
            ),
            const SizedBox(height: 24),

            // Transaction Info
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildRow("Reference ID", "TXN202405291430"),
                    _buildRow("Type", transaction.title),
                    _buildRow("Date & Time", transaction.dateTime.toString()),
                    _buildRow("Payment Method", "Bank Transfer"),
                    _buildRow("Account", "****1234 - GTBank"),
                    _buildRow("Loan Amount", "₦${transaction.amount}"),
                    _buildRow("Interest Rate", "${5}% per month"),
                    _buildRow("Tenor", "3 months"),
                    _buildRow("Total Repayable", "₦60,000.00"),
                  ],
                ),
              ),
            ),
//toStringAsFixed(2)
            // Description
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child:
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Description", style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0F2D62),
                    )
                    ),
                    SizedBox(height: 10),
                     Text("Your loan application has been approved and funds have been successfully disbursed to your registered bank account. Repayment will begin on June 29, 2024."),
                  ],
                  )
              ),
            ),

            // Download Receipt Button
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Color(0xff9C8FFF),
              ),
              onPressed: () {},
              child: const Text("Download Receipt", style: TextStyle(
                color: Color(0xffFFFFFF)
              ),),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

