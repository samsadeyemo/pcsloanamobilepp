import 'package:flutter_riverpod/flutter_riverpod.dart';

final loanStatusProvider = FutureProvider<bool>((ref) async {
  await Future.delayed(Duration(seconds: 1)); // simulate network delay
  return true; // or false based on what you want to test
});
