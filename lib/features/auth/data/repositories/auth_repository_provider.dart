import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/features/auth/providers/auth_provider.dart';
import 'package:pcsloan/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_repository.dart';


final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final envProvider = Provider((ref) => dotenv.env);

final apiServiceProvider = Provider((ref) {
  final env = ref.watch(envProvider);
  return ApiService(env['API_URL'] ?? 'https://api.loanapp.com');
});


final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthRepository(apiService, prefs);
});