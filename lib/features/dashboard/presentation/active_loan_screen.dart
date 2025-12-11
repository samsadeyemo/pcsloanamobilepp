import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custom_actions_button.dart';
import 'package:pcsloan/common/widgets/custom_app_bar.dart';
import 'package:pcsloan/common/widgets/custom_bottom_nav_bar.dart';
import 'package:pcsloan/features/dashboard/providers/loan_provider.dart';
import 'package:intl/intl.dart';
import 'package:pcsloan/utils/local_storage.dart';

class ActiveLoanScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? dashData;
  const ActiveLoanScreen({super.key, this.dashData});

  @override
  ConsumerState<ActiveLoanScreen> createState() => _ActiveLoanScreen();
}

class _ActiveLoanScreen extends ConsumerState<ActiveLoanScreen> {
  String? _userName;
  String loanStatus = "";
  double amountRequested = 0;
  double totalToRepay = 0;
  double amountRepaid = 0;
  double balanceLeft = 0;
  String tenure = "";
  double repaymentProgress = 0.0;
  Map<String, dynamic>? recentTransactions;
  String nextRepaymentDate = "";
  

  @override
  void initState() {
    super.initState();
    _loadUserNameOnce();
    _loadDash();
  }

  void _loadDash() {
    final data = widget.dashData;
    if (data != null) {
      setState(() {
        loanStatus = data['loanStatus'] ?? "";
        String amountDouble = data['amountRequested'];
        amountRequested = double.tryParse(amountDouble) ?? 0.0;
        totalToRepay = data['totalToRepay']?.toDouble() ?? 0.0;
        amountRepaid = data['amountRepaid']?.toDouble() ?? 0.0;
        balanceLeft = data['balanceLeft']?.toDouble() ?? 0.0;
        tenure = data['tenure'].toString();

        repaymentProgress = data['repaymentProgress']?.toDouble() ?? 0.0;
        recentTransactions = data['recentTransactions'] ?? [];
        nextRepaymentDate = data['nextRepaymentDate'] ?? "";
      });
    }
  }

  Future<void> _loadUserNameOnce() async {
    try {
      final data = await LocalStorage.getUser();
      print("object data: $data");
      final name = data?['first_name']?.toString().trim();
      if (!mounted) return;

      setState(() {
        _userName = (name?.isNotEmpty ?? false) ? name : null;
      });
    } catch (e, st) {
      debugPrint('❌ Failed to load username: $e\n$st');
      if (!mounted) return;
      setState(() => _userName = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = _userName ?? "User";
    final loanState = ref.watch(loanProvider);

    if (loanState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    // Error state
    if (loanState.error != null) {
      return Scaffold(body: Center(child: Text('Error: ${loanState.error}')));
    }
    final loan = loanState.loan!;
    final String profileImageUrl =
        "https://fareedtijani.vercel.app/assets/FareedTijani-BrMuVf91.jpg";

    return Scaffold(
      appBar: CustomAppBar(
        userName: userName,
        profileImageUrl: profileImageUrl,
        onProfileTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ActiveLoanScreen()),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(),
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 6,
                  color: Color(0xff7C70DF),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 12),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              loanStatus,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xffFFFFFF),
                              ),
                            ),
                            Icon(Icons.info_outlined, color: Color(0xffFFFFFF)),
                          ],
                        ),
                        Text(
                          formatCurrency(amountRequested),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFFFFFF),
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildRow(
                          'Total to Repay:',
                          formatCurrency(totalToRepay),
                        ),
                        _buildRow(
                          'Amount Repaid:',
                          formatCurrency(amountRepaid),
                        ),
                        _buildRow('Balance:', formatCurrency(balanceLeft)),
                        _buildRow('Tenure:', '${tenure} Months'),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                              0.1,
                            ), // Semi-transparent white
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.transparent, // Subtle border
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Repayment Progress',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '${repaymentProgress}%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              LinearProgressIndicator(
                                value: repaymentProgress ,
                                minHeight: 8,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 290,
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                // Navigate to repayment progress screen
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(
                                  0.1,
                                ), // Almost transparent white
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
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
                SizedBox(height: 20),
                Text(
                  "Quick Actions",
                  style: TextStyle(
                    color: Color(0xff0F2D62),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ActionBox(
                      icon: Icons.credit_card,
                      label: "Make Repayment",
                      iconColor: Color(0xff7C70DF),
                      iconOpacity: Color(0xff7C70DF).withOpacity(0.3),
                      onTap: () {
                        // Repayment logic
                      },
                    ),
                    ActionBox(
                      iconOpacity: Color(0xff4DB6AC).withOpacity(0.2),
                      icon: Icons.calendar_month,
                      label: "Schedule",
                      iconColor: Color(0xff4DB6AC),
                      onTap: () {
                        // Schedule logic
                      },
                    ),
                  ],
                ),
                Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: BorderSide(
                      color: Colors.grey.shade100, // Border color
                      width: 1.5, // Border width
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed:
                              () => context.go(
                                '/all-transactions',
                              ), // Route to new screen
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
                          :
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3, // Limit to 3 for this card
                          
                        itemBuilder: (context, index) {
                          final tx = (recentTransactions?['transactions'] ?? [])[index];
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
                                        ? Color(0xff7C70DF)
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
                                        ? Color(0xff7C70DF)
                                        : Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          // Row(
                          //   children: [
                          //     Icon(
                          //       Icons.notifications,
                          //       size: 22,
                          //       color: Color(0xff0F2D62),
                          //     ),
                          //     SizedBox(width: 10),
                          //     Text(
                          //       'Next Repayment Due',
                          //       style: TextStyle(
                          //         fontSize: 18,
                          //         fontWeight: FontWeight.bold,
                          //         color: Color(0xFF1F2937),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          // SizedBox(height: 8),
                          // Text(
                          //   'Your next repayment of ₦25,000.00 is due on April 15, 2025.',
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     color: Color(0xFF6B7280),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Color(0xffFFFFFF))),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xffFFFFFF),
            ),
          ),
        ],
      ),
    );
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_NG', // Nigerian locale
      symbol: '₦',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
}
