import 'package:pcsloan/features/auth/domain/models/login_request.dart';
import 'package:pcsloan/features/auth/domain/models/sign_up_request.dart';

class AuthRepository {
  Future<String> login(LoginRequest request) async {
    await Future.delayed(const Duration(seconds: 2)); // simulate latency
    if (request.phoneNumber == "+2341234567890" &&
        request.password == "123456") {
      // return fake JWT
      return "mock_jwt_token_123";
    }
    throw Exception("Invalid credentials");
  }

  /// Simulated signup – replace with real HTTP call later.
  Future<String> signUp(SignUpRequest request) async {
    await Future.delayed(const Duration(seconds: 2));
   
    return "mock_signup_token_456"; 
  }
}

/*
  Future<String> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_BASE_URL']}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    }
    throw Exception('Invalid credentials');
  }
  */