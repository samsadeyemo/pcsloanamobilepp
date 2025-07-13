import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/features/auth/data/repository/auth_repository.dart';
import 'package:pcsloan/features/auth/domain/models/login_request.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final loginStateProvider =
    StateNotifierProvider<LoginNotifier, AsyncValue<void>>((ref) {
      final repo = ref.read(authRepositoryProvider);
      return LoginNotifier(repo);
    });

class LoginNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repo;

  LoginNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> login(LoginRequest request) async {
    state = const AsyncValue.loading();
    try {
      await _repo.login(request);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
