import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/animated_cancelled_loan.dart';
import 'package:pcsloan/common/widgets/animated_loan_section.dart';
import 'package:pcsloan/common/widgets/custom_actions_button.dart';
import 'package:pcsloan/common/widgets/custom_app_bar.dart';
import 'package:pcsloan/common/widgets/custom_bottom_nav_bar.dart';
import 'package:pcsloan/common/widgets/loan_review_card.dart';
import 'package:pcsloan/features/dashboard/providers/loan_provider.dart';
import 'package:intl/intl.dart';
import 'package:pcsloan/features/profile/presentation/profile_screen.dart';
import 'package:pcsloan/utils/local_storage.dart';

class ActiveLoanScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? dashData;
  const ActiveLoanScreen({super.key, this.dashData});

  @override
  ConsumerState<ActiveLoanScreen> createState() => _ActiveLoanScreen();
}

class _ActiveLoanScreen extends ConsumerState<ActiveLoanScreen> {
  String? _userName;
  String? _imageUrl;
  String loanStatus = "";
  double amountRequested = 0;
  double totalToRepay = 0;
  double amountRepaid = 0;
  double balanceLeft = 0;
  String tenure = "";
  double repaymentProgress = 0.0;
  Map<String, dynamic>? recentTransactions;
  String nextRepaymentDate = "";
  String loanId = "";

  // ── status flags ─────────────────────────────────────────────────────────
  bool showPending = false; // PENDING_APPROVAL
  bool showKyc = false; // PENDING_DISBURSEMENT | PENDING_VERIFICATION
  bool showCancelled = false; // CANCELLED | CLOSED

  String changeLoanTalk = "";

  @override
  void initState() {
    super.initState();
    _loadUserNameOnce();
    _loadDash();
  }

  void _loadDash() {
    final data = widget.dashData;
    if (data == null) return;

    final status = data['loanStatus'] ?? "";

    // PAID_OFF → go to NoLoanScreen immediately, kill back stack
    if (status == 'PAID_OFF') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/no-loan');
      });
      return;
    }

    setState(() {
      loanStatus = status;
      final amountRaw = data['amountRequested'];
      amountRequested =
          amountRaw is String
              ? double.tryParse(amountRaw) ?? 0.0
              : (amountRaw?.toDouble() ?? 0.0);
      totalToRepay = data['totalToRepay']?.toDouble() ?? 0.0;
      amountRepaid = data['amountRepaid']?.toDouble() ?? 0.0;
      balanceLeft = data['balanceLeft']?.toDouble() ?? 0.0;
      tenure = data['tenure'].toString();
      repaymentProgress = data['repaymentProgress']?.toDouble() ?? 0.0;
      recentTransactions = data['recentTransactions'];
      nextRepaymentDate = data['nextRepaymentDate'] ?? "";
      loanId = data['id'] ?? "";
      print('Loaded loan data: $data');
      print('Loaded id: $loanId');

      // Reset all flags
      showPending = false;
      showKyc = false;
      showCancelled = false;
      changeLoanTalk = "";

      switch (status) {
        case 'PENDING_APPROVAL':
          showPending = true;
          changeLoanTalk = "Pending";
          break;

        case 'PENDING_DISBURSEMENT':
        case 'PENDING_VERIFICATION':
          showKyc = true;
          changeLoanTalk = "Pending";
          break;

        case 'CANCELLED':
        case 'CLOSED':
          showCancelled = true;
          break;

        case 'ACTIVE':
        case 'APPROVED':
          changeLoanTalk = "Active";
          break;

        // NOT_ACTIVE, PENDING_UNDERWRITER, PENDING_ACCEPTANCE — ignored
        default:
          break;
      }
    });
  }

  Future<void> _loadUserNameOnce() async {
    try {
      final data = await LocalStorage.getUser();
      if (!mounted) return;
      final name = data?['first_name']?.toString().trim();
      final profileUrl = data?['profile_picture'];
      setState(() {
        _imageUrl = (profileUrl?.isNotEmpty ?? false) ? profileUrl : null;
        _userName = (name?.isNotEmpty ?? false) ? name : null;
      });
    } catch (e, st) {
      if (!mounted) return;
      debugPrint('❌ Failed to load username: $e\n$st');
      setState(() => _userName = null);
    }
  }

  Future<void> _handleRefresh() async {
    context.go('/loan-redirect');
  }

  /// True when the full active loan card + quick actions + transactions
  /// should render (ACTIVE or APPROVED, no terminal/pending state)
  bool get isActiveLoan => !showPending && !showKyc && !showCancelled;

  @override
  Widget build(BuildContext context) {
    final userName = _userName ?? "User";
    final userImage = _imageUrl ?? "";
    final loanState = ref.watch(loanProvider);

    if (loanState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (loanState.error != null) {
      return Scaffold(body: Center(child: Text('Error: ${loanState.error}')));
    }

    return Scaffold(
      appBar: CustomAppBar(
        userName: userName,
        profileImageUrl: userImage,
        onProfileTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen()),
            ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: const Color(0xff7C70DF),
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── PENDING_APPROVAL ────────────────────────────────────
                  if (showPending) LoanReviewCard(status: 'review'),

                  // ── PENDING_DISBURSEMENT | PENDING_VERIFICATION ─────────
                  if (showKyc) LoanReviewCard(status: 'verification'),

                  // ── CANCELLED | CLOSED ──────────────────────────────────
                  if (showCancelled)
                    AnimatedCancelledLoan(
                      amountRequested: amountRequested,
                      tenure: tenure,
                      loanStatus: loanStatus,
                      onTryAgain: () {
                        context.go('/loan_application');
                      },
                      onContactSupport: () {
                        // TODO: push to your support / contact route
                      },
                    ),

                  // ── PENDING states — big purple pending card ─────────────
                  if (showPending || showKyc)
                    AnimatedPendingLoan(
                      amountRequested: amountRequested,
                      tenure: tenure,
                      isKycIncomplete: showKyc,
                    ),

                  // ── ACTIVE | APPROVED — full loan card ──────────────────
                  if (isActiveLoan) ...[
                    Card(
                      elevation: 6,
                      color: const Color(0xff7C70DF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  changeLoanTalk,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xffFFFFFF),
                                  ),
                                ),
                                const Icon(
                                  Icons.info_outlined,
                                  color: Color(0xffFFFFFF),
                                ),
                              ],
                            ),
                            Text(
                              formatCurrency(amountRequested),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffFFFFFF),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildRow(
                              'Total to Repay:',
                              formatCurrency(totalToRepay),
                            ),
                            _buildRow(
                              'Amount Repaid:',
                              formatCurrency(amountRepaid),
                            ),
                            _buildRow('Balance:', formatCurrency(balanceLeft)),
                            _buildRow('Tenure:', '$tenure Months'),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Repayment Progress',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${(repaymentProgress).toStringAsFixed(1)}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 7),
                                  LinearProgressIndicator(
                                    value: (repaymentProgress / 100).clamp(0.0, 1.0),
                                    minHeight: 8,
                                    backgroundColor: Colors.white.withOpacity(
                                      0.2,
                                    ),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 290,
                                height: 50,
                                child: TextButton(
                                  onPressed: () => context.push(
                                '/repayment-overview',
                                extra: {
                                  'loanId': loanId,
                                }, // replace loanId with whatever your variable is
                              ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white.withOpacity(
                                      0.1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'View Repayment Progress',
                                    style: TextStyle(color: Color(0xffFFFFFF)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      "Quick Actions",
                      style: TextStyle(
                        color: Color(0xff0F2D62),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ActionBox(
                          icon: Icons.credit_card,
                          label: "Make Repayment",
                          iconColor: const Color(0xff7C70DF),
                          iconOpacity: const Color(0xff7C70DF).withOpacity(0.3),
                          onTap:
                              () => context.push(
                                '/repayment-overview',
                                extra: {
                                  'loanId': loanId,
                                }, // replace loanId with whatever your variable is
                              ),
                        ),
                        ActionBox(
                          iconOpacity: const Color(0xff4DB6AC).withOpacity(0.2),
                          icon: Icons.calendar_month,
                          label: "Schedule",
                          iconColor: const Color(0xff4DB6AC),
                          onTap:
                              () => context.push(
                                '/repayment-schedule',
                                extra: {'loanId': loanId},
                              ),
                        ),
                      ],
                    ),
                    if (recentTransactions != null &&
                        (recentTransactions?['transactions'] ?? []).isNotEmpty)
                      Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                          side: BorderSide(
                            color: Colors.grey.shade100,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                onPressed:
                                    () => context.push('/transactions-history'),
                                child: const Text(
                                  'View All',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            recentTransactions == null ||
                                    (recentTransactions?['transactions'] ?? [])
                                        .isEmpty
                                ? const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'No recent transactions available.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                                : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    final tx =
                                        (recentTransactions?['transactions'] ??
                                            [])[index];
                                    return ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              tx['isCredit']
                                                  ? Colors.deepPurple[100]
                                                  : Colors.pink[50],
                                        ),
                                        child: Icon(
                                          tx['isCredit']
                                              ? Icons.arrow_downward
                                              : Icons.arrow_upward,
                                          color:
                                              tx['isCredit']
                                                  ? const Color(0xff7C70DF)
                                                  : Colors.red,
                                        ),
                                      ),
                                      title: Text(
                                        tx['type'],
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                      subtitle: Text(
                                        tx['date'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      trailing: Text(
                                        tx['isCredit']
                                            ? '+ ${formatCurrency(tx['amount'])}'
                                            : '- ${formatCurrency(tx['amount'])}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              tx['isCredit']
                                                  ? const Color(0xff7C70DF)
                                                  : Colors.red,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          ],
                        ),
                      ),
                    if (nextRepaymentDate.isNotEmpty) _buildNextRepaymentCard(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xffFFFFFF))),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xffFFFFFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextRepaymentCard() {
    final monthlyInstallment =
        tenure.isNotEmpty ? totalToRepay / double.parse(tenure) : 0.0;

    final parsed = DateTime.tryParse(nextRepaymentDate);
    final formattedDate =
        parsed != null ? DateFormat('MMMM d, yyyy').format(parsed) : '';

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xff7C70DF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xff7C70DF),
              size: 20,
            ),
          ),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Next Repayment Due',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0F2D62),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your next repayment of ${formatCurrency(monthlyInstallment)} is due\non $formattedDate',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  height: 1.4,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
}
