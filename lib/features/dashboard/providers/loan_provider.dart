// lib/features/loans/data/providers/loan_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/features/dashboard/data/notifier/loan_notifier.dart';


final loanProvider = StateNotifierProvider<LoanNotifier, LoanState>((ref) {
  final notifier = LoanNotifier();
  // Trigger initial check (can be moved to LoginScreen if preferred)
  notifier.checkLoanStatus();
  return notifier;
});