import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoanState {
  final bool isLoading;
  final bool hasOutstandingLoan;
  final Map<String, dynamic>? loan;
  final String? error;

  LoanState({
    this.isLoading = false,
    this.hasOutstandingLoan = false,
    this.loan,
    this.error,
  });

  LoanState copyWith({
    bool? isLoading,
    bool? hasOutstandingLoan,
    Map<String, dynamic>? loan,
    String? error,
  }) {
    return LoanState(
      isLoading: isLoading ?? this.isLoading,
      hasOutstandingLoan: hasOutstandingLoan ?? this.hasOutstandingLoan,
      loan: loan ?? this.loan,
      error: error ?? this.error,
    );
  }
}

class LoanNotifier extends StateNotifier<LoanState> {
  LoanNotifier() : super(LoanState());

  Future<void> checkLoanStatus() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      final hasLoan = await _fetchLoanStatus(); // Use loanStatusProvider
      if (hasLoan) {
        final mockLoan = {
          'amount': 250000.0,
          'totalToRepay': 300000.0,
          'amountRepaid': 100000.0,
          'balance': 200000.0,
          'tenureMonths': 12,
          'repaymentProgress': 33.3,
          'status': 'Active',
          'transactions': [
            {'type': 'Loan Disbursement', 'date': 'Jan 15, 2025', 'amount': 250000.0, 'isCredit': true},
            {'type': 'Monthly Repayment', 'date': 'Feb 15, 2025', 'amount': -25000.0, 'isCredit': false},
            {'type': 'Monthly Repayment', 'date': 'Mar 15, 2025', 'amount': -25000.0, 'isCredit': false},
          ],
          'nextRepaymentDue': {'date': 'Apr 15, 2025', 'amount': 25000.0},
        };
        state = state.copyWith(isLoading: false, hasOutstandingLoan: true, loan: mockLoan);
      } else {
        state = state.copyWith(isLoading: false, hasOutstandingLoan: false, loan: null);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Helper to fetch loan status from loanStatusProvider
  Future<bool> _fetchLoanStatus() async {
    // This could be replaced with a real API call later
    return true; // Default to true for now, matching your provider
  }
}