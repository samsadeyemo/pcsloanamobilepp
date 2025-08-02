import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final envProvider = Provider((ref) => dotenv.env);

final apiServiceProvider = Provider((ref) {
  final env = ref.watch(envProvider); // Reads .env
  return ApiService(
    env['API_URL'] ?? 'https://api.loanapp.com',
  ); // Initializes ApiService
});

// Auth state
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
      userId: userId ?? this.userId, // Updates or keeps current
      error: error ?? this.error,
    );
  }
}

// Auth state management
class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService apiService; // API service for auth
  final SharedPreferences prefs; // Persistence

  AuthNotifier(this.apiService, this.prefs)
    : super(
        AuthState(
          token: prefs.getString('token'), // Loads saved token
          userId: prefs.getString('userId'), // Loads saved user ID
        ),
      );

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null); // Sets loading
    try {
      final response = await apiService.login(
        email,
        password,
      ); // Calls login API
      await prefs.setString('token', response['token']); // Saves token
      await prefs.setString('userId', response['userId']); // Saves user ID
      state = state.copyWith(
        isLoading: false,
        token: response['token'],
        userId: response['userId'],
      ); // Updates state
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      ); // Sets error
    }
  }

  void logout() {
    prefs.remove('token'); // Removes token
    prefs.remove('userId'); // Removes user ID
    state = state.copyWith(
      token: null,
      userId: null,
      error: null,
    ); // Clears state
  }
}

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiService = ref.watch(apiServiceProvider); // Gets API service
  final prefs = ref.watch(sharedPreferencesProvider); // Gets SharedPreferences
  return AuthNotifier(apiService, prefs); // Creates AuthNotifier
});