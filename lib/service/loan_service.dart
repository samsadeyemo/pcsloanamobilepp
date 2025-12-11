import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pcsloan/config/app_config.dart';
import 'package:pcsloan/main.dart';
import 'package:pcsloan/service/api_exception.dart';
import 'package:pcsloan/utils/local_storage.dart';

class LoanService {
  final String baseUrl = appConfig.apiBaseUrl;
  final String xApiKey = appConfig.xApiKey;


  Future<List<dynamic>> fetchApplicationLoanData() async {
  final applicationLoanData = await apiClient.get(
    '/loans/offers', 
    includeXApiKey: true,
  );
  
  
  // Safely extract the data
  final data = applicationLoanData['data'];
  
  if (data is! List) {
    throw ApiException('Unexpected data format: ${data.runtimeType}');
  }

  return List<dynamic>.from(data);
}

  Future<Map<String, dynamic>> applyForLoan({
    required double loanAmount,
    required String loanName,
    required double intrestRate,
    required int tenure,
  }) async {
    // final userToken = await LocalStorage.getToken();
    // final url = Uri.parse('$baseUrl/loans');
    // final Map<String, dynamic> body = {
    //   'name': loanName,
    //   "amount": loanAmount,
    //   "interest_rate": intrestRate,
    //   "tenure": tenure,
    // };
    // final response = await http.post(
    //   url,
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'x-api-key': xApiKey,
    //     'Authorization': 'Bearer $userToken',
    //   },
    //   body: jsonEncode(body),
    // );

    // final decoded = jsonDecode(response.body);

    // if ((response.statusCode == 200 || response.statusCode == 201) &&
    //     decoded['status'] == 'success') {
    //   return decoded;
    // } else {
    //   throw ApiException(decoded['message'] ?? 'Loan Application Failed');
    // }

    return await apiClient.post(
      '/loans',
      body: {
        'name': loanName,
        "amount": loanAmount,
        "interest_rate": intrestRate,
        "tenure": tenure,
      },
      includeXApiKey: true,
    );
  }

  Future<Map<String, dynamic>> getLoanOverView({
    required double loanAmount,
    required String loanOfferId,
    required int tenure,
  }) async {

    return await apiClient.post(
      '/loans/overview',
      body: {
        "loan_offer_id": loanOfferId,
        "amount": loanAmount,
        "tenure": tenure,
      },
      includeXApiKey: true,
    );
  }

  
Future<Map<String, dynamic>> getUserDashboard()async {
  return await apiClient.get(
    '/users/dashboard',
    includeXApiKey: true,
  );
}
}

