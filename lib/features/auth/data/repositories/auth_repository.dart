import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio;
  AuthRepository(this._dio);

  // Fetch employee details using employeeId
  // Future<Map<String, dynamic>> fetchEmployeeDetails(String id) async {
  //   try {
  //     final response = await _dio.get('/auth/$id');
  //     return response.data["data"] as Map<String, dynamic>;
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       throw e;
  //     }
  //     rethrow;
  //   }
  // }

  Future<Map<String, dynamic>> fetchEmployeeDetails(String id) async {
    try {
      final response = await _dio.get('/auth/$id');
      // return wrapper (e.g. { status: 'success', data: {...} } )
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      // forward the DioException so caller can inspect e.response?.data
      if (e.response != null) {
        throw e;
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createAccount(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _dio.post("/auth/register", data: payload);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null) {
        throw e; // SignupNotifier will parse this
      }
      rethrow;
    }
  }
}
