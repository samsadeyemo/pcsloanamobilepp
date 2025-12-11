import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pcsloan/config/app_config.dart';
import 'package:pcsloan/main.dart';
import 'package:pcsloan/service/api_exception.dart';
import 'package:pcsloan/utils/local_storage.dart';


class TransactionService{
  final String baseUrl = appConfig.apiBaseUrl;
  final String xApiKey = appConfig.xApiKey;

  Future<Map<String, dynamic>> fetchTransactionHistory() async {
    return await apiClient.get(
      '/transactions', 
      includeXApiKey: true,
    );
  }
}