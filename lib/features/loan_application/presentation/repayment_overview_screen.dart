import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pcsloan/service/loan_service.dart';

class RepaymentOverviewScreen extends StatefulWidget {
  final String loanId;

  const RepaymentOverviewScreen({super.key, required this.loanId});

  @override
  State<RepaymentOverviewScreen> createState() =>
      _RepaymentOverviewScreenState();
}

class _RepaymentOverviewScreenState extends State<RepaymentOverviewScreen> {
  bool isLoading = true;
  String? error;

  // Loan fields
  double originalLoanAmount = 0;
  double totalRepayment = 0;
  double amountPaid = 0;
  double balance = 0;
  double repaymentProgress = 0;
  int tenure = 0;
  String nextPaymentDue = "";
  double nextAmountDue = 0;
  final _loanService = LoanService();

  List<dynamic> schedules = [];

  @override
  void initState() {
    super.initState();
    _fetchLoan();
  }

  Future<void> _fetchLoan() async {
    try {
      final response = await _loanService.getLoan(widget.loanId);
      final data = response['data'];
      print('Loan Overview Data: $data'); // Debug log
      schedules = data['schedules'] ?? [];
      schedules.sort((a, b) {
        final dateA = DateTime.tryParse(a['due_date'] ?? '') ?? DateTime(9999);
        final dateB = DateTime.tryParse(b['due_date'] ?? '') ?? DateTime(9999);
        return dateA.compareTo(dateB);
      });

      final rawTotal = data['totalRepayment']?.toString() ?? '';
      final parsedTotal = double.tryParse(rawTotal);

      final parsedNextAmount =
          double.tryParse(data['nextAmountDue']?.toString() ?? '') ?? 0.0;
      final parsedTenure =
          data['tenure'] is int
              ? data['tenure'] as int
              : int.tryParse(data['tenure'].toString()) ?? 1;

      // If backend returns corrupted totalRepayment, fallback to nextAmountDue * tenure
      final resolvedTotal =
          (parsedTotal != null && parsedTotal > 0 && rawTotal.length < 15)
              ? parsedTotal
              : parsedNextAmount * parsedTenure;

      final parsedOriginal =
          double.tryParse(data['originalLoanAmount']?.toString() ?? '') ?? 0.0;
      final parsedAmountPaid =
          double.tryParse(data['amountPaid'].toString()) ?? 0.0;
      final resolvedBalance =
          (data['outstandingBalance'] != null)
              ? double.tryParse(data['outstandingBalance'].toString()) ?? 0.0
              : resolvedTotal - parsedAmountPaid;

      final progress =
          resolvedTotal > 0 ? (parsedAmountPaid / resolvedTotal) : 0.0;

      setState(() {
        originalLoanAmount = parsedOriginal;
        totalRepayment = resolvedTotal;
        amountPaid = parsedAmountPaid;
        balance = resolvedBalance;
        repaymentProgress = progress.clamp(0.0, 1.0);
        tenure = parsedTenure;
        nextPaymentDue = data['nextPaymentDue'] ?? '';
        nextAmountDue = parsedNextAmount;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Map<String, dynamic>? get _nextUnpaidSchedule {
    final unpaid =
        schedules.where((s) {
          final amountDue = double.tryParse(s['amount_due'].toString()) ?? 0.0;
          final amountPaid =
              double.tryParse(s['amount_paid'].toString()) ?? 0.0;
          return amountDue != amountPaid && s['status'] != 'PAID';
        }).toList();

    if (unpaid.isEmpty) return null;

    unpaid.sort((a, b) {
      final dateA = DateTime.tryParse(a['due_date'] ?? '') ?? DateTime(9999);
      final dateB = DateTime.tryParse(b['due_date'] ?? '') ?? DateTime(9999);
      return dateA.compareTo(dateB);
    });

    return unpaid.first;
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(amount);
  }

  String formatDate(String isoDate) {
    final parsed = DateTime.tryParse(isoDate);
    if (parsed == null) return '';
    return DateFormat('dd/MM/yyyy').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(body: Center(child: Text('Error: $error')));
    }

    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xffF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xff0F2D62),
              size: 20,
            ),
          ),
        ),
        title: const Text(
          'Repayment Overview',
          style: TextStyle(
            color: Color(0xff0F2D62),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Purple Summary Card ──────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff7C70DF),
                          Color(0xff9B8FFF),
                          Color(0xffA89EFF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff7C70DF).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Current Loan label + amount
                        const Text(
                          'Current Loan',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          formatCurrency(originalLoanAmount),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Original Amount',
                          style: TextStyle(fontSize: 12, color: Colors.white60),
                        ),

                        const SizedBox(height: 22),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 16),

                        // Total to Repay
                        _buildCardRow(
                          'Total to Repay',
                          formatCurrency(totalRepayment),
                          false,
                        ),
                        const SizedBox(height: 4),
                        const Divider(color: Colors.white12, height: 1),
                        const SizedBox(height: 4),

                        // Amount Paid
                        _buildCardRow(
                          'Amount Paid',
                          formatCurrency(amountPaid),
                          false,
                        ),
                        const SizedBox(height: 4),
                        const Divider(color: Colors.white12, height: 1),
                        const SizedBox(height: 4),

                        // Balance — bold
                        _buildCardRow('Balance', formatCurrency(balance), true),

                        const SizedBox(height: 20),

                        // Repayment Progress
                        // Container(
                        //   padding: const EdgeInsets.all(14),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white.withOpacity(0.12),
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           const Text(
                        //             'Repayment Progress',
                        //             style: TextStyle(
                        //               fontSize: 12,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //           Text(
                        //             '${(repaymentProgress * 100).toStringAsFixed(1)}%',
                        //             style: const TextStyle(
                        //               fontSize: 12,
                        //               color: Colors.white,
                        //               fontWeight: FontWeight.w600,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       const SizedBox(height: 10),
                        //       LinearProgressIndicator(
                        //         value: repaymentProgress,
                        //         minHeight: 8,
                        //         backgroundColor:
                        //             Colors.white.withOpacity(0.2),
                        //         valueColor:
                        //             const AlwaysStoppedAnimation<Color>(
                        //                 Colors.white),
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Next Repayment Details ───────────────────────────────
                  const Text(
                    'Next Repayment Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0F2D62),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Next Due Date row
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Next Due Date',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff6B7280),
                                ),
                              ),
                              Text(
                                formatDate(nextPaymentDue),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff0F2D62),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Divider(color: Colors.grey.shade100, height: 1),

                        // Next Repayment Amount row
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Next Repayment Amount',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff6B7280),
                                ),
                              ),
                              Text(
                                formatCurrency(nextAmountDue),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0F2D62),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Repayment Reminder box
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        //   child: Container(
                        //     padding: const EdgeInsets.all(14),
                        //     decoration: BoxDecoration(
                        //       color: const Color(0xffF3F4F6),
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child: Row(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Container(
                        //           width: 22,
                        //           height: 22,
                        //           decoration: BoxDecoration(
                        //             color: const Color(0xff7C70DF)
                        //                 .withOpacity(0.15),
                        //             shape: BoxShape.circle,
                        //           ),
                        //           child: const Center(
                        //             child: Text(
                        //               'i',
                        //               style: TextStyle(
                        //                 fontSize: 12,
                        //                 fontWeight: FontWeight.bold,
                        //                 color: Color(0xff7C70DF),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         const SizedBox(width: 10),
                        //         const Expanded(
                        //           child: Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               Text(
                        //                 'Repayment Reminder',
                        //                 style: TextStyle(
                        //                   fontSize: 13,
                        //                   fontWeight: FontWeight.w700,
                        //                   color: Color(0xff0F2D62),
                        //                 ),
                        //               ),
                        //               SizedBox(height: 4),
                        //               Text(
                        //                 'Your repayment will be automatically debited on the due date. Ensure sufficient balance in your account.',
                        //                 style: TextStyle(
                        //                   fontSize: 12,
                        //                   color: Color(0xff6B7280),
                        //                   height: 1.5,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Transactions list ────────────────────────────────────
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     TextButton(
                  //       onPressed: () => context.push('/transactions-history'),
                  //       child: const Text(
                  //         'View All',
                  //         style: TextStyle(
                  //           color: Color(0xff7C70DF),
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1.5,
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: schedules.take(3).length,
                      separatorBuilder:
                          (_, __) =>
                              Divider(color: Colors.grey.shade100, height: 1),
                      itemBuilder: (context, index) {
                        final tx = schedules[index];
                        final amountDue =
                            double.tryParse(tx['amount_due'].toString()) ?? 0.0;
                        final dueDate = DateTime.tryParse(tx['due_date'] ?? '');
                        final formattedDate =
                            dueDate != null
                                ? DateFormat('MMM d, yyyy').format(dueDate)
                                : '';

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xff7C70DF,
                                  ).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  tx['status'] == 'PAID'
                                      ? Icons.check_rounded
                                      : Icons.radio_button_unchecked_rounded,
                                  color: const Color(0xff7C70DF),
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Monthly Repayment',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff0F2D62),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff9CA3AF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                formatCurrency(amountDue),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff7C70DF),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 100), // space above bottom button
                ],
              ),
            ),
          ),

          // ── Repay Now button ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: const Color(0xffF9FAFB),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed:
                    () => context.push(
                      '/repay/loan',
                      extra: {
                        'loanId': widget.loanId,
                        'amount': nextAmountDue,
                        'scheduleId': _nextUnpaidSchedule?['id'] ?? '',
                      }, // replace loanId with whatever your variable is
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff7C70DF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xff7C70DF).withOpacity(0.4),
                ),
                child: const Text(
                  'Repay Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardRow(String label, String value, bool isBold) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
