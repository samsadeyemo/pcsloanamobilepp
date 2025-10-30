import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/utils/local_storage.dart';

class LoanRedirectScreen extends ConsumerStatefulWidget {
  const LoanRedirectScreen({super.key});

  @override
  ConsumerState<LoanRedirectScreen> createState() => _LoanRedirectScreenState();
}

class _LoanRedirectScreenState extends ConsumerState<LoanRedirectScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoanStatus();
  }

  Future<void> _checkLoanStatus() async {
    final hasLoan = await LocalStorage.hasLoan();
    if (!mounted) return;

    if (hasLoan) {
      context.go("/active-loan");
    } else {
      context.go("/no-loan");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
