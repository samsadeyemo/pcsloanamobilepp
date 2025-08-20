import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/common/widgets/custom_loan_app_false.dart';
import 'package:pcsloan/common/widgets/loan_loading_indicator.dart';
import 'package:go_router/go_router.dart';

class LoanStatusScreen extends ConsumerStatefulWidget {
  const LoanStatusScreen({super.key});

  @override
  ConsumerState<LoanStatusScreen> createState() => _LoanStatusScreenState();
}

class _LoanStatusScreenState extends ConsumerState<LoanStatusScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoNavigate();
  }

  void _startAutoNavigate() {
    debugPrint('Timer started for auto-navigation');
    _timer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        debugPrint('Timer fired - navigating to LoanSummary');
        context.push('/loan-summary');
      } else {
        debugPrint('Widget not mounted - skipping navigation');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer if widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomLoanAppBarFalse(title: 'We’re Reviewing Your Application',),
     
           
      backgroundColor: const Color(0xffFFFFFF),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Align(
              alignment: Alignment.center,
              child: DualRingSpinner(
                message: "Processing your application...",
                icon: Icons.trending_up_outlined,
                size: 150,
              ),
            ),
            const SizedBox(height: 90),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
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
                  child: const Column(
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
                        'Our system is reviewing your application. This usually takes 3–5 seconds.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 8),
                    Text(
                      "You will be automatically redirected to your loan offer",
                      style: TextStyle(color: Color(0xff4B5563), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
