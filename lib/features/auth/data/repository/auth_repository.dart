
import 'package:pcsloan/features/auth/domain/models/login_request.dart';

class AuthRepository {
  Future<bool> login(LoginRequest request) async {
    await Future.delayed(const Duration(seconds: 2)); // simulate network delay

    // Normally you’d call an actual API here
    if (request.phoneNumber == "test@example.com" && request.password == "123456") {
      return true;
    }
    throw Exception("Invalid credentials");
  }
}
