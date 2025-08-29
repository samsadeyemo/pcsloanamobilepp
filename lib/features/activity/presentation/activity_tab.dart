import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/common/widgets/custom_activity_bottom_nav_bar.dart';
import 'package:pcsloan/common/widgets/custom_activity_finance_card.dart';
import 'package:pcsloan/common/widgets/custom_activity_finance_summary_card.dart';
import 'package:pcsloan/features/activity/data/transaction_model.dart';
import 'package:pcsloan/features/activity/presentation/transaction_detail_screen.dart';

class ActivityTab extends ConsumerStatefulWidget {
  const ActivityTab({super.key});

  @override
  ConsumerState<ActivityTab> createState() => _ActivityTabState();
}

class _ActivityTabState extends ConsumerState<ActivityTab> {
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
      dateTime: 'Apr 28, 4:45 PM',
      amount: '+₦30,000.00',
      isCredit: true,
    ),
    Transaction(
      title: 'Interest Charge',
      dateTime: 'Apr 25, 12:00 PM',
      amount: '-₦2,500.00',
      isCredit: false,
    ),
    Transaction(
      title: 'Fund Transfer',
      dateTime: 'Apr 20, 9:30 AM',
      amount: '+₦15,000.00',
      isCredit: true,
    ),
    Transaction(
      title: 'Loan Application Fee',
      dateTime: 'Apr 14, 2:00 PM',
      amount: '-₦1,000.00',
      isCredit: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        title: Text(
          "Activity",
          style: TextStyle(
            color: Color(0xff0F2D62),
            fontSize: 18,
            fontFamily: "Inter",
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffFFFFFF),
      ),
      bottomNavigationBar: CustomActionBottomNavBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomActivityFinanceCard(
                totalInflow: 80000,
                percentageChange: 15.2,
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomActivityFinanceSummaryCard(
                    price: '₦20,000',
                    label: 'Total Outflows',
                    subtext: 'This month ↓ -8.1%',
                    icon: Icons.trending_down,
                    iconColor: Color(0xff9C8FFF),
                  ),
                  SizedBox(width: 10),
                  CustomActivityFinanceSummaryCard(
                    price: '₦30,000',
                    label: 'Pending',
                    subtext: 'Due soon',
                    icon: Icons.access_time,
                    iconColor: Color(0xffFF9500),
                    isUrgent: true,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0,),
                    child: Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0F2D62),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implement view all action
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff00B7BD),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return ListTile(
                      leading: Icon(
                        tx.isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                        color: tx.isCredit ? Colors.green : Colors.red,
                      ),
                      title: Text(tx.title, style: TextStyle(fontSize: 14),),
                      subtitle: Text(tx.dateTime, style: TextStyle(fontSize: 12),),
                      trailing: Text(
                        tx.amount,
                        style: TextStyle(
                          color: tx.isCredit ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    TransactionDetailsScreen(transaction: tx),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
