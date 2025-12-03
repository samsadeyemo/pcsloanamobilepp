// import 'dart:convert';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'package:pcsloan/auth_storage/token_storage.dart';
// import 'package:pcsloan/config/app_config.dart';

// class ApiClient {
//   final AppConfig appConfig;
//   final TokenStorage tokenStorage;

//   ApiClient({
//     required this.appConfig,
//     required this.tokenStorage,
//   });

//   Uri _buildUrl(String path) {
//     return Uri.parse('${appConfig.apiBaseUrl}$path');
//   }

//   Future<http.Response> get(String path) async {
//     final token = await tokenStorage.getToken();
//     final url = _buildUrl(path);

//     final headers = <String, String>{
//       'Content-Type': 'application/json',
//       if (token != null) 'Authorization': 'Bearer $token',
//     };

//     try {
//       final response = await http.get(url, headers: headers)
//           .timeout(const Duration(seconds: 15));
//       return response;
//     } on TimeoutException {
//       throw Exception('Request timed out');
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }

//   Future<http.Response> post(String path, {Map<String, dynamic>? body}) async {
//     final token = await tokenStorage.getToken();
//     final url = _buildUrl(path);

//     final headers = <String, String>{
//       'Content-Type': 'application/json',
//       if (token != null) 'Authorization': 'Bearer $token',
//     };

//     try {
//       final response = await http
//           .post(url, headers: headers, body: jsonEncode(body ?? {}))
//           .timeout(const Duration(seconds: 15));
//       return response;
//     } on TimeoutException {
//       throw Exception('Request timed out');
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }
// }


import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pcsloan/auth_storage/token_storage.dart';
import 'package:pcsloan/config/app_config.dart';
import 'package:pcsloan/service/api_exception.dart';

class ApiClient {
  final AppConfig appConfig;
  final TokenStorage tokenStorage;

  ApiClient({
    required this.appConfig,
    required this.tokenStorage,
  });

  Uri _buildUrl(String path) {
    return Uri.parse('${appConfig.apiBaseUrl}$path');
  }

  Future<Map<String, dynamic>> get(String path) async {
    final token = await tokenStorage.getToken();
    final url = _buildUrl(path);

    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers)
          .timeout(const Duration(seconds: 15));
      
      final decoded = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && 
          decoded['status'] == 'success') {
        return decoded;
      } else {
        throw ApiException(decoded['message'] ?? 'Request failed');
      }
    } on TimeoutException {
      throw ApiException('Request timed out');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    final token = await tokenStorage.getToken();
    final url = _buildUrl(path);

    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode(body ?? {}))
          .timeout(const Duration(seconds: 15));
      
      final decoded = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && 
          decoded['status'] == 'success') {
        return decoded;
      } else {
        throw ApiException(decoded['message'] ?? 'Request failed');
      }
    } on TimeoutException {
      throw ApiException('Request timed out');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}

