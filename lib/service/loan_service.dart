import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pcsloan/config/app_config.dart';
import 'package:pcsloan/utils/local_storage.dart';

class LoanService {
  final String baseUrl = appConfig.apiBaseUrl;
  final String xApiKey = appConfig.xApiKey;
  final String userToken = LocalStorage.getUser().then((user) => user?['token'] ?? '').toString();

  Future<Map<String, dynamic>> fetchApplicationLoanData() async {
    final url = Uri.parse('$baseUrl/loans/offers');
    

    final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': xApiKey,
      'Authorization': 'Bearer $userToken',
    },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['status'] == 'success') {
      return body['data'] ?? {};
    } else {
      throw Exception(body['message'] ?? 'Loan data not found');
    }
  }

  
}
