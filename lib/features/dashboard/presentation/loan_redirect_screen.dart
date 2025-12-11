import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/service/loan_service.dart';
import 'package:pcsloan/utils/local_storage.dart';

class LoanRedirectScreen extends ConsumerStatefulWidget {
  const LoanRedirectScreen({super.key});

  @override
  ConsumerState<LoanRedirectScreen> createState() => _LoanRedirectScreenState();
}

class _LoanRedirectScreenState extends ConsumerState<LoanRedirectScreen> {
  bool _fetching = false;
  final _loanService = LoanService();

  @override
  void initState() {
    super.initState();
    _checkLoanStatus();
  }

  Future<void> _checkLoanStatus() async {
    setState(() => _fetching = true);

    try {
      final dashboardData = await _loanService.getUserDashboard();
      final hasActiveLoan = dashboardData['data']['hasloans'] as bool? ?? false;
      if (!mounted) return;

      if (hasActiveLoan) {
        context.go(
          "/active-loan",
          extra:{
              "loanStatus": dashboardData['data']['activeLoan']['status'],
              "amountRequested": dashboardData['data']['activeLoan']['amount'],
              "totalToRepay": dashboardData['data']['totalToRepay'],
              "amountRepaid": dashboardData['data']['amountRepaid'],
              "balanceLeft": dashboardData['data']['balance'],
              "tenure": dashboardData['data']['tenure'],
              "repaymentProgress": dashboardData['data']['repaymentProgress'],
              "recentTransactions": dashboardData['data']['transactions'],
              "nextRepaymentDate": dashboardData['data']['nextPaymentDueDate'],
          } ,
          );
      } else {
        context.go("/no-loan");
      }
    } catch (e) {
      debugPrint('❌ Error fetching dashboard data: $e');
      if (!mounted) return;
      // Fallback to local storage check
      final hasLoan = await LocalStorage.hasLoan();
      if (!mounted) return;

      if (hasLoan) {
        context.go("/active-loan");
      } else {
        context.go("/no-loan");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
