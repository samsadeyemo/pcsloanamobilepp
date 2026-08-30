import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/features/activity/data/transaction_model.dart';
import 'package:pcsloan/features/activity/presentation/transaction_detail_screen.dart';
import 'package:pcsloan/service/loan_service.dart';

class RecentTransactionsPage extends ConsumerStatefulWidget {
  const RecentTransactionsPage({super.key});

  @override
  ConsumerState<RecentTransactionsPage> createState() =>
      _RecentTransactionsPageState();
}

class _RecentTransactionsPageState
    extends ConsumerState<RecentTransactionsPage> {
  List<Transaction> transactions = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _getTransactionHistory();
  }

  Future<void> _getTransactionHistory() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loanService = LoanService();
      final response = await loanService.getTransactionHistory();
      print('✅ Transaction history: $response');

      // response shape: {status, statusCode, message, data: [...], error}
      final List<dynamic> data = response['data'] ?? [];

      final parsed =
          data
              .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
              .toList();

      if (!mounted) return;
      setState(() {
        transactions = parsed;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error fetching transaction history: $e');
      if (!mounted) return;
      setState(() {
        errorMessage = 'Could not load transactions. Please try again.';
        isLoading = false;
      });
    }
  }

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
        backgroundColor: const Color(0xffFFFFFF),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getTransactionHistory,
          ),
          const SizedBox(width: 10),
        ],
      ),
      backgroundColor: const Color(0xffFFFFFF),
      body: RefreshIndicator(
        onRefresh: _getTransactionHistory,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return ListView(
        // wrapped in ListView so pull-to-refresh still works on error
        children: [
          const SizedBox(height: 120),
          Icon(Icons.error_outline, size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Center(
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      );
    }

    if (transactions.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 120),
          Icon(
            Icons.receipt_long_outlined,
            size: 40,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'No transactions yet.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TransactionDetailsScreen(transactionId: tx.id),
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
    );
  }
}
