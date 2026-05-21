import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pcsloan/service/loan_service.dart';

class RepaymentScheduleScreen extends StatefulWidget {
  final String loanId;

  const RepaymentScheduleScreen({super.key, required this.loanId});

  @override
  State<RepaymentScheduleScreen> createState() =>
      _RepaymentScheduleScreenState();
}

class _RepaymentScheduleScreenState extends State<RepaymentScheduleScreen> {
  final _loanService = LoanService();
  bool isLoading = true;
  String? error;
  List<dynamic> scheduleItems = [];

  @override
  void initState() {
    super.initState();
    _fetchLoanSchedule();
  }

  Future<void> _fetchLoanSchedule() async {
    try {
      final response = await _loanService.getLoanSchedule(widget.loanId);
      final data = response['data'];
      setState(() {
        scheduleItems = data as List<dynamic>;
        scheduleItems.sort((a, b) {
          final dateA =
              DateTime.tryParse(a['due_date'] ?? '') ?? DateTime(9999);
          final dateB =
              DateTime.tryParse(b['due_date'] ?? '') ?? DateTime(9999);
          return dateA.compareTo(dateB);
        });
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
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
    return DateFormat('MMM d, yyyy').format(parsed);
  }

  double _totalAmountDue() {
    return scheduleItems.fold(0.0, (sum, item) {
      return sum + (double.tryParse(item['amount_due'].toString()) ?? 0.0);
    });
  }

  double _totalAmountPaid() {
    return scheduleItems.fold(0.0, (sum, item) {
      return sum + (double.tryParse(item['amount_paid'].toString()) ?? 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xffF9FAFB),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xff7C70DF)),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: const Color(0xffF9FAFB),
        appBar: _buildAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xff7C70DF),
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                'Something went wrong',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff0F2D62),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                error!,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    error = null;
                  });
                  _fetchLoanSchedule();
                },
                child: const Text(
                  'Try Again',
                  style: TextStyle(color: Color(0xff7C70DF)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final paidCount = scheduleItems.where((i) => i['status'] == 'PAID').length;
    final totalCount = scheduleItems.length;
    final progressValue = totalCount > 0 ? paidCount / totalCount : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Summary Card ───────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff4A3FC0),
                    Color(0xff7C70DF),
                    Color(0xff9B8FFF),
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
                  // Payments label
                  const Text(
                    'Repayment Schedule',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$paidCount of $totalCount Payments',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Completed',
                    style: TextStyle(fontSize: 12, color: Colors.white60),
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 16),

                  // Total due vs paid
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryTile(
                          'Total Due',
                          formatCurrency(_totalAmountDue()),
                        ),
                      ),
                      Container(width: 1, height: 36, color: Colors.white24),
                      Expanded(
                        child: _buildSummaryTile(
                          'Total Paid',
                          formatCurrency(_totalAmountPaid()),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Progress bar
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Repayment Progress',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${(progressValue * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: progressValue,
                          minHeight: 8,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Schedule list label ────────────────────────────────────────
            const Text(
              'Payment Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff0F2D62),
              ),
            ),
            const SizedBox(height: 14),

            // ── Schedule items ─────────────────────────────────────────────
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: scheduleItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = scheduleItems[index];
                final amountDue =
                    double.tryParse(item['amount_due'].toString()) ?? 0.0;
                final amountPaid =
                    double.tryParse(item['amount_paid'].toString()) ?? 0.0;
                final status = item['status']?.toString() ?? 'PENDING';
                final dueDate = formatDate(item['due_date'] ?? '');
                final paymentDate =
                    item['payment_date'] != null
                        ? formatDate(item['payment_date'])
                        : null;
                final isPaid = status == 'PAID';

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade100, width: 1.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Index circle
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xff7C70DF).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child:
                                isPaid
                                    ? const Icon(
                                      Icons.check_rounded,
                                      color: Color(0xff7C70DF),
                                      size: 18,
                                    )
                                    : Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff7C70DF),
                                      ),
                                    ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Payment ${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff0F2D62),
                                    ),
                                  ),
                                  // Status pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xff7C70DF,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      status,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff7C70DF),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // Due date
                              _buildDetailRow(
                                Icons.calendar_today_outlined,
                                'Due Date',
                                dueDate,
                              ),

                              const SizedBox(height: 6),

                              // Amount due
                              _buildDetailRow(
                                Icons.account_balance_wallet_outlined,
                                'Amount Due',
                                formatCurrency(amountDue),
                              ),

                              if (isPaid) ...[
                                const SizedBox(height: 6),
                                _buildDetailRow(
                                  Icons.check_circle_outline_rounded,
                                  'Amount Paid',
                                  formatCurrency(amountPaid),
                                ),
                                if (paymentDate != null) ...[
                                  const SizedBox(height: 6),
                                  _buildDetailRow(
                                    Icons.event_available_outlined,
                                    'Paid On',
                                    paymentDate,
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
        'Repayment Schedule',
        style: TextStyle(
          color: Color(0xff0F2D62),
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSummaryTile(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white60),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xff7C70DF)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 12, color: Color(0xff9CA3AF)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xff0F2D62),
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
