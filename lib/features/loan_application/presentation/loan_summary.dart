import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pcsloan/common/widgets/gradient_action_button.dart';

class LoanSummary extends ConsumerStatefulWidget {
  final Map<String, dynamic>? loanData;
  const LoanSummary({super.key, this.loanData});

  @override
  ConsumerState<LoanSummary> createState() => _LoanSummary();
}

class _LoanSummary extends ConsumerState<LoanSummary> {
  String tenure = "";
  String amount = "";
  String loanId = "";
  String intrestRate = "";
  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    debugPrint("I collect am jare");
    setState(() {
      final formatter = NumberFormat('#,##0.00', 'en_US');
      tenure = widget.loanData?['tenure'].toString() ?? "";
      loanId = widget.loanData?['loan_id'] ?? "";
      intrestRate = widget.loanData?['intrest_rate'].toString() ?? "";
      final rawAmount = widget.loanData?['amount'];
    double amountValue;

    if (rawAmount is num) {
      amountValue = rawAmount.toDouble();
    } else if (rawAmount is String) {
      amountValue = double.tryParse(rawAmount) ?? 0;
    } else {
      amountValue = 0;
    }

    amount = formatter.format(amountValue);
    });
    print(widget.loanData);
  }


  
  // Future<void> _applyForLoan() async {
  //   print(loanAmount);
  //   print(maxNorm);
  //   print(minNorm);
  //   if (loanAmount > maxNorm) {
  //     _showSnackBar(
  //       "The maximum amount you can borrow is ₦$maxLimit",
  //       isError: true,
  //     );
  //     return;
  //   } else if (loanAmount < minNorm) {
  //     _showSnackBar(
  //       "The minimum amount you can borrow is ₦$minLimit",
  //       isError: true,
  //     );
  //     return;
  //   } else if (loanName.length <= 1) {
  //     _showSnackBar("The loan purpose must not be empty", isError: true);
  //     return;
  //   } else if (selectedTenure.isEmpty) {
  //     _showSnackBar("You must select a tenure", isError: true);
  //     return;
  //   }

  //   setState(() => _applying = true);
  //   try {
  //     final result = await _loanService.applyForLoan(
  //       loanAmount: loanAmount,
  //       loanName: loanName,
  //       tenure: int.parse(selectedTenure),
  //       intrestRate: double.parse(intrestRate),
  //     );
  //     print(result);
  //     String resultMessage = result["message"] ?? "Loan Applied successfully";
  //     _showSnackBar(resultMessage, isError: false);
  //     String loanOfferId = result["data"]["loan_id"] ?? "";
  //     print(loanOfferId);
  //     context.go(
  //       "/Loan-status-screen",
  //       extra: {
  //         'loan_id': loanOfferId,
  //         'amount': loanAmount,
  //         'tenure': int.parse(selectedTenure),
  //         'intrest_rate': intrestRate,
  //       },
  //     );
  //   } catch (e) {
  //     _showSnackBar(
  //       e.toString().replaceFirst('Exception: ', ''),
  //       isError: true,
  //     );
  //   } finally {
  //     if (mounted) setState(() => _applying = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              radius: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black54, size: 16),
                onPressed: () {
                  context.go('/loan-redirect');
                }, // do something when pressed
              ),
            ),
          ),
        ],
        title: Text(
          'Review Loan Offer',
          style: TextStyle(color: Color(0xff0F2D62), fontSize: 18),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffFFFFFF),
      ),
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 400,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xff7C70DF), // Left side
                        Color(0xffA198FF), // Right side
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoRow(label: 'Loan Amount', value: '₦${amount}'),
                      SizedBox(height: 16),
                      InfoRow(label: 'Tenor', value: '${tenure} Months'),
                      SizedBox(height: 16),
                      InfoRow(label: 'Interest Rate', value: '${intrestRate}% p.a.'),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total to Repay',
                      style: TextStyle(fontSize: 14, color: Color(0xff4B5563)),
                    ),
                    Text(
                      '₦600,000',
                      style: TextStyle(fontSize: 16, color: Color(0xff4B5563)),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Monthly Payment',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff4B5563),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '₦25,000',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff4B5563),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Anticipated Disbursement',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff4B5563),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Jan 20, 2025',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff4B5563),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                Text(
                  'Repayment Schedule Preview',
                  style: TextStyle(
                    color: Color(0xff0F2D62),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),

                Card(
                  elevation: 0,
                  color: Color(0xffF9FAFB),

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
                              '1st Repayment',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff4B5563),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Feb 20, 2025 - ₦25,000',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff1F2937),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '1st Repayment',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff4B5563),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Feb 20, 2025 - ₦25,000',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff1F2937),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '1st Repayment',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff4B5563),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Feb 20, 2025 - ₦25,000',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff1F2937),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),

                        Divider(thickness: 2, color: Color(0xFFE5E7EB)),
                      ],
                    ),
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
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.info,
                              size: 25,
                              color: Color(0xff7C70DF),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'This offer is valid for 48 hours. Interest rates may vary based on final credit assessment.',
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
                SizedBox(height: 10),
                Divider(thickness: 2, color: Color(0xFFE5E7EB)),
                SizedBox(height: 10),

                SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/loan_application');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xffE5E7EB), Color(0xffA198FF)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                GradientActionButton(
                  text: "Accept Offer",
                  size: 18,
                  onPressed: () {
                    context.push("/bvn-verification-screen");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
