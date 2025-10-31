import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custom_bottom_nav_bar.dart';
import 'package:pcsloan/common/widgets/custom_loan_app_bar.dart';
import 'package:pcsloan/common/widgets/custom_tenure_button.dart';
import 'package:pcsloan/common/widgets/gradient_action_button.dart';

class ApplyForLoan extends ConsumerStatefulWidget {
  const ApplyForLoan({super.key});

  @override
  ConsumerState<ApplyForLoan> createState() => _ApplyForLoan();
}

class _ApplyForLoan extends ConsumerState<ApplyForLoan> {
  String? selectedTenure;
  @override
  Widget build(BuildContext context) {
    String loanAmount = '';

    final List<String> tenures = [
      '3 Months',
      '6 Months',
      '12 Months',
      '18 Months',
      '24 Months',
      '36 Months',
    ];
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: CustomLoanAppBar(title: 'Apply for a Loan',),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Loan Amount",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F2D62),
                    fontFamily: "Inter",
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF7C70DF), width: 1.5),
                    borderRadius: BorderRadius.circular(10),

                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) => loanAmount = value,
                          validator:
                              (value) =>
                                  value != null && value.length >= 6
                                      ? null
                                      : "The Minimum amount you can borrow is ₦10,000",
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Color(0xFFADAEBC),
                              fontSize: 16,
                              fontFamily: "Inter",
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Min: ₦10,000',
                      style: TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                    ),
                    Text(
                      'Max: ₦2,000,000',
                      style: TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                    ),
                  ],
                ),
                SizedBox(height: 70),
                Text(
                  'Select Tenure (Months)',
                  style: TextStyle(
                    color: Color(0xff4B5563),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10),

                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2,
                  // padding: const EdgeInsets.all(16),
                  children:
                      tenures.map((tenure) {
                        return MonthButton(
                          label: tenure,
                          isSelected: selectedTenure == tenure,
                          onTap: () {
                            setState(() {
                              selectedTenure = tenure;
                            });
                          },
                        );
                      }).toList(),
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
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 25,
                                color: Color(0xff7C70DF),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'You are eligible for this loan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 8),
                          Text(
                            'Based on your profile and employment status, you qualify for up to ₦2,000,000.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: GradientActionButton(
                      text: "Continue",
                      size: 18,
                      onPressed: () {
                        context.go("/Loan-status-screen");
                      },
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
}
