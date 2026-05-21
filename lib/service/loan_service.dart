import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pcsloan/config/app_config.dart';
import 'package:pcsloan/main.dart';
import 'package:pcsloan/service/api_exception.dart';
import 'package:pcsloan/utils/local_storage.dart';

class LoanService {
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

  Future<Map<String, dynamic>> getUserDashboard() async {
    return await apiClient.get('/users/dashboard', includeXApiKey: true);
  }

  

  Future<List<dynamic>> getBankList() async {
    return await apiClient.getList('/paystack/banks', includeXApiKey: true);
  }

  Future<Map<String, dynamic>> verifyBankAccount({
    required String accountNumber,
    required String bankCode,
  }) async {

    try {
      final response = await apiClient.post(
        '/paystack/banks/resolve',
        body: {"account_number": accountNumber, "bank_code": bankCode},
      );

      print('✅ API Response received: $response');
      return response;
    } catch (e) {
      print('❌ API Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> linkBankAccount({
    required String accountNumber,
    required String bankCode,
  }) async {
    try {
      final response = await apiClient.put(
        '/users/bank',
        body: {"account_number": accountNumber, "bank_code": bankCode},
      );

      print('✅ API Response received: $response');
      return response;
    } catch (e) {
      print('❌ API Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserBvn() async {
    return await apiClient.get('/users/bvn', includeXApiKey: true);
  }

  Future<Map<String, dynamic>> getLoan(String loanId) async {
    return await apiClient.get('/loans/$loanId', includeXApiKey: true);
  }

  Future<Map<String, dynamic>> getLoanSchedule(String loanId) async {
    return await apiClient.get('/loans/schedule/$loanId', includeXApiKey: true);
  }

  Future<Map<String, dynamic>> payLoan(String loanId, double amount, String schedule_id) async {
    return await apiClient.post(
      '/loans/pay',
      body: {
        "loan_id": loanId,
        "amount": amount,
        "schedule_id": schedule_id,
        "is_full_payment": false
      },
      includeXApiKey: true,
    );
  }

  Future<Map<String, dynamic>> payFullLoan(String loanId) async {
    return await apiClient.post(
      '/loans/pay',
      body: {
        "loan_id": loanId,
        "is_full_payment": true},
      includeXApiKey: true,
    );
  }
  
}
