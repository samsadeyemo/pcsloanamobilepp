import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pcsloan/config/app_config.dart';
import 'package:pcsloan/utils/local_storage.dart';

class LoanService {
  final String baseUrl = appConfig.apiBaseUrl;
  final String xApiKey = appConfig.xApiKey;
    

  
  

  // Future<List<dynamic>> fetchApplicationLoanData() async {
  //    final  userToken = await LocalStorage.getToken(); 

  //   final url = Uri.parse('$baseUrl/loans/offers');
  //   print('This is the XAPI - $xApiKey');
  //   print('This is the user Token - $userToken');

  //   final response = await http.get(
  //   url,
  //   headers: {
  //     'Content-Type': 'application/json',
  //     'x-api-key': xApiKey,
  //     'Authorization': 'Bearer $userToken',
  //   },
  //   );
  //   final body = jsonDecode(response.body);

  //   if (response.statusCode == 200 && body['status'] == 'success') {
  //     return body['data'] ?? {};
  //   } else {
  //     throw Exception(body['message'] ?? 'Loan data not found');
  //   }
  // }

  Future<List<dynamic>> fetchApplicationLoanData() async {
  final userToken = await LocalStorage.getToken();

  final url = Uri.parse('$baseUrl/loans/offers');
  print('➡️ X-API-Key: $xApiKey');
  print('➡️ Token: $userToken');

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
    // ✅ Ensure it's a List
    if (body['data'] is List) {
      return body['data'];
    } else {
      throw Exception('Unexpected data format');
    }
  } else {
    throw Exception(body['message'] ?? 'Loan data not found');
  }
}



}
