import 'package:flutter/material.dart';
import 'package:pcsloan/features/activity/data/transaction_model.dart';
import 'package:pcsloan/service/loan_service.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final String transactionId;

  const TransactionDetailsScreen({Key? key, required this.transactionId})
      : super(key: key);

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  Transaction? transaction;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _getTransactionDetail();
  }

  Future<void> _getTransactionDetail() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loanService = LoanService();
      final response =
          await loanService.getTransactionDetail(widget.transactionId);
      print('✅ Transaction detail: $response');

      // response shape: {status, statusCode, message, data: {transaction: {...}}, error}
      final Map<String, dynamic>? txJson = response['data'];

      if (txJson == null) {
        throw Exception('Transaction not found in response');
      }

      if (!mounted) return;
      setState(() {
        transaction = Transaction.fromJson(txJson);
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error fetching transaction detail: $e');
      if (!mounted) return;
      setState(() {
        errorMessage = 'Could not load this transaction. Please try again.';
        isLoading = false;
      });
    }
  }

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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null || transaction == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 40, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                errorMessage ?? 'Something went wrong.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _getTransactionDetail,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final tx = transaction!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Success Icon & Amount
          Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: tx.isCredit
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                child: Icon(
                  tx.isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                  color: tx.isCredit ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tx.status ?? 'Unknown',
                style: TextStyle(
                  color: (tx.status ?? '').toUpperCase() == 'SUCCESS'
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                tx.amount,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: tx.isCredit ? Colors.green : Colors.red,
                ),
              ),
              Text(tx.title),
            ],
          ),
          const SizedBox(height: 24),

          // Transaction Info
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildRow("Reference ID", tx.reference ?? '—'),
                  _buildRow("Type", tx.title),
                  _buildRow("Date & Time", tx.dateTime),
                  _buildRow("Payment Method", tx.paymentMethod ?? '—'),
                  _buildRow("Status", tx.status ?? '—'),
                  _buildRow("Amount", tx.amount),
                ],
              ),
            ),
          ),

          // Description
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0F2D62),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(_descriptionFor(tx)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: const Color(0xff9C8FFF),
            ),
            onPressed: () {
              // TODO: implement receipt download
            },
            child: const Text(
              "Download Receipt",
              style: TextStyle(color: Color(0xffFFFFFF)),
            ),
          ),
        ],
      ),
    );
  }

  String _descriptionFor(Transaction tx) {
    switch (tx.title) {
      case 'Loan Disbursement':
        return 'Your loan application has been approved and funds have been successfully disbursed to your registered account.';
      case 'Loan Repayment':
        return 'This repayment has been applied to your active loan balance.';
      case 'Processing Fee':
        return 'This is a processing fee charged on your loan.';
      case 'Penalty Charge':
        return 'This charge was applied due to a missed or late repayment.';
      default:
        return 'Transaction reference ${tx.reference ?? ''} — ${tx.paymentMethod ?? 'payment'} — status ${tx.status ?? 'unknown'}.';
    }
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