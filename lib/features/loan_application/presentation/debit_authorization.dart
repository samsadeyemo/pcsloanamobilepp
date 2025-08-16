import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/common/widgets/custom_loan_app_bar.dart';

class DebitAuthorizationScreen extends ConsumerStatefulWidget {
  const DebitAuthorizationScreen({super.key});

  @override
  ConsumerState<DebitAuthorizationScreen> createState() =>
      _DebitAuthorizationScreen();
}

class _DebitAuthorizationScreen
    extends ConsumerState<DebitAuthorizationScreen> {
  @override
  Widget build(BuildContext context) {
    final List<String> benefits = [
      'Never miss a payment deadline',
      'Build a positive credit history',
      'Avoid late payment penalties',
      'Convenient and stress-free',
    ];
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: CustomLoanAppBar(title: 'Debit Authorization'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffA198FF).withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.question_mark_rounded,
                            color: Color(0xff7C70DF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Secure Payment Authorization',
                    style: TextStyle(color: Color(0xff0F2D62), fontSize: 20),
                  ),
                ),
                SizedBox(height: 10),

                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      Center(
                        child: Text('To ensure seamless loan repayments, we'),
                      ),
                      Center(
                        child: Text(
                          'require your authorization to debit your linked',
                        ),
                      ),
                      Center(
                        child: Text('bank account. This is a one-time setup.'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7C70DF),
                        Color(0xFFA198FF),
                      ], // Purple gradient
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Monthly Payment',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          Text(
                            '₦25,000',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'First Payment Date',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          Text(
                            'Dec 15, 2025',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Loan Tenure',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '24 months',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xffEFF6FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.info, color: Color(0xff7C70DF)),
                          SizedBox(width: 3),
                          Text(
                            'How Authorization Works',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),
                      StepItem(
                        number: '1',
                        text:
                            'You\'ll be redirected to our secure payment partner.',
                      ),
                      StepItem(
                        number: '2',
                        text: 'Enter your bank details to authorize debits.',
                      ),
                      StepItem(
                        number: '3',
                        text:
                            'Automatic deductions will begin on your due date.',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Authorization Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFF1E0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Pending',
                              style: TextStyle(
                                color: Color(0xFFFF8C00),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Payment Method Section
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            // Icon Placeholder
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.credit_card,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Text Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Payment Method',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Not yet authorized',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Alert Icon
                            const Icon(
                              Icons.error_outline,
                              color: Color(0xFFFF8C00),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF6F3FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lock Icon
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFFD9C9FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF5E3DB3),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Text Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Bank-Level Security',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Your banking information is encrypted and protected. We never store your card details and only use authorized payment partners.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFEFF8FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Color(0xff7C70DF)),
                          const Text(
                            'Why authorize auto-debit?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      ...benefits.map(
                        (benefit) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: Color(0xFF7C70DF),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  benefit,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Divider(thickness: 2, color: Color(0xFFE5E7EB)),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: SizedBox(
                    width: 342,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // handle biometric login
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
                            colors: [Color(0xff7C70DF), Color(0xffA198FF)],
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.question_mark,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Authorize Payment Method",
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
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      return null;
                    },
                    child: Text(
                      "I'll set this up later",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffA198FF),
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.lock_outline, color: Colors.grey, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Secured by Flutterwave',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StepItem extends StatelessWidget {
  final String number;
  final String text;

  const StepItem({required this.number, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Color(0xff7C70DF),
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
