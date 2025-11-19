import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pcsloan/config/app_config.dart';
import 'package:pcsloan/service/api_exception.dart';
import 'package:pcsloan/utils/local_storage.dart';

class LoanService {
  final String baseUrl = appConfig.apiBaseUrl;
  final String xApiKey = appConfig.xApiKey;

  Future<List<dynamic>> fetchApplicationLoanData() async {
    final userToken = await LocalStorage.getToken();

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

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        body['status'] == 'success') {
      // ✅ Ensure it's a List
      if (body['data'] is List) {
        return body['data'];
      } else {
        throw ApiException('Unexpected data format');
      }
    } else {
      throw ApiException(body['message'] ?? 'Loan data not found');
    }
  }

  Future<Map<String, dynamic>> applyForLoan({
    required double loanAmount,
    required String loanName,
    required double intrestRate,
    required int tenure,
  }) async {
    final userToken = await LocalStorage.getToken();
    final url = Uri.parse('$baseUrl/loans');
    final Map<String, dynamic> body = {
      'name': loanName,
      "amount": loanAmount,
      "interest_rate": intrestRate,
      "tenure": tenure,
    };
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': xApiKey,
        'Authorization': 'Bearer $userToken',
      },
      body: jsonEncode(body),
    );

    final decoded = jsonDecode(response.body);

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        decoded['status'] == 'success') {
      return decoded;
    } else {
      throw ApiException(decoded['message'] ?? 'Loan Application Failed');
    }
  }

  Future<Map<String, dynamic>> getLoanOverView({
    required double loanAmount,
    required String loanOfferId,
    required int tenure,
  }) async {
    final userToken = await LocalStorage.getToken();
    final url = Uri.parse('$baseUrl/loans/overview');
    final Map<String, dynamic> body = {
      "loan_offer_id": loanOfferId,
      "amount": loanAmount,
      "tenure": tenure,
    };
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': xApiKey,
        'Authorization': 'Bearer $userToken',
      },
      body: jsonEncode(body),
    );

    final decoded = jsonDecode(response.body);

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        decoded['status'] == 'success') {
      return decoded;
    } else {
      throw ApiException(decoded['message'] ?? 'Could not get Loan offer');
    }
  }
}
