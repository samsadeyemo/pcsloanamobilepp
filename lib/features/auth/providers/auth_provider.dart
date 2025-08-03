import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/features/auth/data/notifier/auth_notifier.dart';
import 'package:pcsloan/features/auth/data/repositories/auth_repository_provider.dart';


final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});