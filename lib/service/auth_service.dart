// lib/features/auth/services/auth_service.dart
import 'package:pcsloan/main.dart';

class AuthService {


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
      'phone': phone,
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

  /// Gets fresh tokens using the stored refresh token (tokens are saved
  /// by the ApiClient). Returns the response `data` map.
  Future<Map<String, dynamic>> refreshToken() => apiClient.refreshSession();

  Future<Map<String, dynamic>> editUserPin({
    required String oldPin,
    required String newPin,
    required String confirmNewPin
  }) async {
    return await apiClient.post(
      '/auth/update/pin',
      body: {
        'old_pin': oldPin,
        "new_pin": newPin,
        "confirm_new_pin": confirmNewPin
        },
      includeXApiKey: true,
    );
  }

  Future<Map<String, dynamic>> editUserPassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewpassword
  }) async {
    return await apiClient.post(
      '/auth/update/password',
      body: {
        'old_password': oldPassword,
        "new_password": newPassword,
        "confirm_new_password": confirmNewpassword
        },
      includeXApiKey: true,
    );
  }

  Future<Map<String, dynamic>> resetForgottenPassword({
    required String otp,
    required String newPassword,
    required String confirmNewpassword
  }) async {
    return await apiClient.post(
      '/auth/reset-password',
      body: {
        'otp': otp,
        "new_password": newPassword,
        "confirm_new_password": confirmNewpassword
        },
      includeXApiKey: true,
    );
  }

  Future<Map<String, dynamic>> resetPassword({
    required String otp,
    required String newPassword,
    required String confirmNewpassword
  }) async {
    return await apiClient.post(
      '/auth/reset-password',
      body: {
        'otp': otp,
        "new_password": newPassword,
        "confirm_new_password": confirmNewpassword
        },
      includeXApiKey: true,
    );
  }

}

