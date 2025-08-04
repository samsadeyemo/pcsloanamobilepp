

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/features/dashboard/presentation/active_loan_screen.dart';
import 'package:pcsloan/features/dashboard/presentation/no_loan_screen.dart';
import 'package:pcsloan/features/dashboard/providers/loan_status_provider.dart';

class LoanRedirectScreen extends ConsumerWidget {
  const LoanRedirectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanStatus = ref.watch(loanStatusProvider);

    return loanStatus.when(
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (hasActiveLoan) {
        if (hasActiveLoan) {
          context.pushReplacement('/active-loan');
        } else {
          context.pushReplacement('/no-loan');
        }
      },
    );
  }
}
