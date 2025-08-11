import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/common/widgets/custom_actions_button.dart';
import 'package:pcsloan/common/widgets/custom_app_bar.dart';
import 'package:pcsloan/common/widgets/custom_bottom_nav_bar.dart';
import 'package:pcsloan/features/dashboard/providers/loan_provider.dart';
import 'package:intl/intl.dart';

class ActiveLoanScreen extends ConsumerStatefulWidget {
  const ActiveLoanScreen({super.key});

  @override
  ConsumerState<ActiveLoanScreen> createState() => _ActiveLoanScreen();
}

class _ActiveLoanScreen extends ConsumerState<ActiveLoanScreen> {
  @override
  Widget build(BuildContext context) {
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
        userName: 'Fareed',
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
                  margin: EdgeInsets.symmetric( vertical: 12),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              'Active Loan',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xffFFFFFF),
                              ),
                            ),
                            Icon(Icons.info_outlined, color: Color(0xffFFFFFF)),
                          ],
                        ),
                        Text(
                          formatCurrency(loan['amount']),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFFFFFF),
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildRow('Total to Repay:', formatCurrency(loan['totalToRepay'])),
                        _buildRow('Amount Repaid:', formatCurrency(loan['amountRepaid'])),
                        _buildRow('Balance:', formatCurrency(loan['balance'])),
                        _buildRow('Tenure:', '${loan['tenureMonths']} Months'),
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
                                    '33.3%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              LinearProgressIndicator(
                                value: loan['repaymentProgress'] / 100,
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
                            width: 250,
                            height: 45,
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

                Text(
                  "Quick Actions",
                  style: TextStyle(
                    color: Color(0xff0F2D62),
                    fontSize: 18,
                  ),
                ),

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
)

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
