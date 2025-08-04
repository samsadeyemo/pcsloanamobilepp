import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/features/dashboard/providers/loan_status_provider.dart';

class LoanRedirectScreen extends ConsumerStatefulWidget {
  const LoanRedirectScreen({super.key});

  @override
  ConsumerState<LoanRedirectScreen> createState() => _LoanRedirectScreenState();
}

class _LoanRedirectScreenState extends ConsumerState<LoanRedirectScreen> {
  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool>>(loanStatusProvider, (prev, next) {
      if (_navigated) return;

      next.whenData((hasLoan) {
        _navigated = true;
        if (hasLoan) {
          context.pushReplacement('/active-loan');
        } else {
          context.pushReplacement('/no-loan');
        }
      });
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
