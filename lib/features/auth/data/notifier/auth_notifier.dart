import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/features/auth/data/repositories/auth_repository.dart';

class AuthState {
  final bool isLoading;
  final String? token;
  final String? userId;
  final String? error;

  AuthState({this.isLoading = false, this.token, this.userId, this.error});

  AuthState copyWith({
    bool? isLoading,
    String? token,
    String? userId,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthNotifier(this.repository)
      : super(
          AuthState(
            token: repository.getToken(),
            userId: repository.getUserId(),
          ),
        );

  Future<void> login(String phoneNumber, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await repository.login(phoneNumber, password);
      state = state.copyWith(
        isLoading: false,
        token: result['token'],
        userId: result['userId'],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void logout() {
    repository.logout();
    state = state.copyWith(token: null, userId: null, error: null);
  }
}