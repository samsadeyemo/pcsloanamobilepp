// lib/features/auth/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pcsloan/config/app_config.dart';

class AuthService {
  final String baseUrl = appConfig.apiBaseUrl;

  /// Fetch employee details using staff ID
  Future<Map<String, dynamic>> fetchEmployee(String employeeNo) async {
    final url = Uri.parse('$baseUrl/auth/$employeeNo');
    print("➡️ GET $url");

    final response = await http.get(url);
    print("⬅️ ${response.body}");

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['status'] == 'success') {
      return body['data'] ?? {};
    } else {
      throw Exception(body['message'] ?? 'Employee not found');
    }
  }

  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required String bvn,
    required String employeeId,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    // Build the request body dynamically
    final Map<String, dynamic> body = {
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "bvn": bvn,
      "employee_id": employeeId,
    };

    // Only include email if it is not empty
    if (email.isNotEmpty) {
      body["email"] = email;
    }

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print("➡️ POST $url");
    print("⬅️ ${response.body}");

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 201 && decoded['status'] == 'success') {
      return decoded;
    } else {
      throw Exception(decoded['message'] ?? 'Registration failed');
    }
  }



  Future<Map<String, dynamic>> verifyOtp({
  required String otp,
  required String phone,
}) async {
  final url = Uri.parse('$baseUrl/auth/verify');

  final Map<String, dynamic> body = {
    'otp': otp,
    'phone': phone,
  };

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  print("➡️ POST $url");
  print("⬅️ ${response.body}");

  final decoded = jsonDecode(response.body);

  if (response.statusCode == 201 && decoded['status'] == 'success') {
    return decoded;
  } else {
    throw Exception(decoded['message'] ?? 'OTP verification failed');
  }
}

}

