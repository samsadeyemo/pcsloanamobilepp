// lib/features/auth/services/auth_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pcsloan/auth_storage/token_storage.dart';
import 'package:pcsloan/config/app_config.dart';
import 'package:pcsloan/main.dart';
import 'package:pcsloan/service/api_exception.dart';

class AuthService {
  final String baseUrl = appConfig.apiBaseUrl;


  Future<Map<String, dynamic>> fetchEmployee(String employeeNo) async {
    return await apiClient.get('/auth/$employeeNo');
  }


  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required String bvn,
    required String employeeId,
  }) async {

    return await apiClient.post('/auth/register', body: {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phone,
      'bvn': bvn,
      'employee_id': employeeId,
    });
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String otp,
    required String phone,
  }) async {
    return await apiClient.post('/auth/verify', body: {
      'otp': otp,
      'phone': phone,
    });
  }

  Future<Map<String, dynamic>> resendVerificationCode(String employeeNo) async {
    return await apiClient.post('/auth/resend', body: {
      'employee_id': employeeNo,
    });
  }

  Future<Map<String, dynamic>> createPassword({
    required String employeeId,
    required String password,
    required String confirmPassword,
  }) async {
    return await apiClient.post('/auth/password', body: {
      'employee_id': employeeId,
      'password': password,
      'confirm_password': confirmPassword,
    });
  }

Future<Map<String, dynamic>> createTransactionPin({
    required String employeeId,
    required String pin,
    required String confirmPin,
  }) async {
    return await apiClient.post('/auth/pin', body: {
      'employee_id': employeeId,
      'pin': pin,
      'confirm_pin': confirmPin,
    });
  }

  



Future<Map<String, dynamic>> loginUser({
  required String phone,
  required String password,
}) async {
  return await apiClient.post('/auth/login', body: {
    'phone': phone,
    'password': password,
  });
}

//includeXApiKey: true,

  Future<Map<String, dynamic>> forgetPassword({
    required String phone,
  })async {
    return await apiClient.post('/auth/forgot-password', body: {
      'phone': phone,
    });

  }

Future<Map<String, dynamic>> refreshToken() async {
    try {
      final tokenStorage = TokenStorage();
      final refreshToken = await tokenStorage.getRefreshToken();
      
      if (refreshToken == null) {
        throw Exception('No refresh token available. Please login again.');
      }

      // Call your refresh token endpoint
      final response = await apiClient.post(
        '/auth/refresh-token',
        body: {
          'refresh_token': refreshToken,
        },
        includeXApiKey: true, // Include API key if required
      );
      print("😇😇$response");
      return response;
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }

}

