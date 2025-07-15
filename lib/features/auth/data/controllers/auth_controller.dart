import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pcsloan/features/auth/data/repository/auth_repository_provider.dart';
import 'package:pcsloan/features/auth/domain/models/login_request.dart';
import 'package:pcsloan/features/auth/data/repository/auth_repository.dart';
import 'package:pcsloan/features/auth/domain/models/sign_up_request.dart';

final secureStorage = FlutterSecureStorage();

enum AuthStatus { loggedOut, authenticating, loggedIn }


class AuthState {
  final AuthStatus status;
  final String? token;
  final String? errorMessage;

  const AuthState._(this.status, {this.token, this.errorMessage});

  factory AuthState.loggedOut({String? errorMessage}) => AuthState._(AuthStatus.loggedOut, errorMessage: errorMessage);
  factory AuthState.authenticating() => const AuthState._(AuthStatus.authenticating);
  factory AuthState.loggedIn(String token) => AuthState._(AuthStatus.loggedIn, token: token);
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  Timer? _inactivityTimer;

  AuthController(this._repo) : super(AuthState.loggedOut()) {
    _tryAutoLogin();
  }

  // Attempt to auto-login using stored token on app launch
  Future<void> _tryAutoLogin() async {
    final token = await secureStorage.read(key: 'auth_token');
    if (token != null) {
      state = AuthState.loggedIn(token);
      _startInactivityTimer();
    }
  }

  // Handle user login
  Future<void> login(LoginRequest request) async {
    state = AuthState.authenticating();
    try {
      final token = await _repo.login(request);
      state = AuthState.loggedIn(token);
      await secureStorage.write(key: 'auth_token', value: token);
      _startInactivityTimer();
    } catch (e) {
      state = AuthState.loggedOut(errorMessage: e.toString());
      rethrow;
    }
  }


   Future<void> signUp(SignUpRequest request) async {
    state = AuthState.authenticating();
    try {
      final token = await _repo.signUp(request);
      state = AuthState.loggedIn(token);
      await secureStorage.write(key: 'auth_token', value: token);
      _startInactivityTimer();
    } catch (e) {
      state = AuthState.loggedOut(errorMessage: e.toString());
      rethrow;
    }
  }


  // Handle user logout
  Future<void> logout() async {
    state = AuthState.loggedOut();
    await secureStorage.delete(key: 'auth_token');
    _inactivityTimer?.cancel();
  }

  // Start inactivity timer to auto-logout after 5 minutes
  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(minutes: 5), () {
      logout();
    });
  }

  // Reset inactivity timer manually when user interacts with the app
  void resetInactivityTimer() {
    if (state.status == AuthStatus.loggedIn) {
      _startInactivityTimer();
    }
  }
}

// Riverpod provider for the AuthController
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthController(repo);
});


