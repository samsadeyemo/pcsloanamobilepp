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
  String? _error;
  final _loanService = LoanService();

  @override
  void initState() {
    super.initState();
    _checkLoanStatus();
  }

  Future<void> _checkLoanStatus() async {
    setState(() => _error = null);

    try {
      final dashboardData = await _loanService.getUserDashboard();
      if (!mounted) return;
      // Session expired: ApiClient is already showing the login prompt
      if (dashboardData['status'] == 'unauthenticated') return;
      final hasActiveLoan = dashboardData['data']['hasloans'] as bool? ?? false;
      

      if (hasActiveLoan) {
        print(dashboardData);
        context.go(
          "/active-loan",
          extra: {
            "loanStatus": dashboardData['data']['activeLoan']['status'],
            "amountRequested": dashboardData['data']['activeLoan']['amount'],
            "totalToRepay": dashboardData['data']['totalToRepay'],
            "amountRepaid": dashboardData['data']['amountRepaid'],
            "balanceLeft": dashboardData['data']['balance'],
            "tenure": dashboardData['data']['tenure'],
            "repaymentProgress": dashboardData['data']['repaymentProgress'],
            "recentTransactions": dashboardData['data']['transactions'],
            "nextRepaymentDate": dashboardData['data']['nextPaymentDueDate'],
            "id": dashboardData['data']['activeLoan']['id'],
          },
        );
      } else {
        context.go("/no-loan");
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint('❌ Error fetching dashboard data: $e');
      
      // Fallback to local storage check
      final hasLoan = await LocalStorage.hasLoan();
      if (!mounted) return;

      if (hasLoan) {
        // The active-loan screen needs the dashboard data, so let them retry
        setState(() => _error = e.toString());
      } else {
        context.go("/no-loan");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _error == null
            ? const CircularProgressIndicator(color: Color(0xff7C70DF))
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 48, color: Color(0xff7C70DF)),
                    const SizedBox(height: 16),
                    const Text(
                      "Couldn't load your loan details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff0F2D62),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Color(0xff4B5563)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _checkLoanStatus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff7C70DF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
