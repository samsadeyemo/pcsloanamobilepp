import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio;
  AuthRepository(this._dio);

  // Fetch employee details using employeeId
  Future<Map<String, dynamic>> fetchEmployeeDetails(String id) async {
    final response = await _dio.get('/auth/$id');
    return response.data["data"] as Map<String, dynamic>;
  }

  // Create account with all user data
  Future<void> createAccount(Map<String, dynamic> payload) async {
    // print(payload);
    // final response = await _dio.post("/auth/register", data: payload);
    // print(response);
    // if (response.statusCode != 200) {
    //   throw Exception("Failed to create account");
    // }
    try {
      print(payload);
      final response = await _dio.post("/auth/register", data: payload);
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        print("Error status: ${e.response?.statusCode}");
        print("Error data: ${e.response?.data}");
      } else {
        print("Request error: ${e.message}");
      }
      rethrow;
    }
  }
}
