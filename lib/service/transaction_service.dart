import 'package:pcsloan/config/app_config.dart';
import 'package:pcsloan/main.dart';


class TransactionService{
  

  Future<Map<String, dynamic>> fetchTransactionHistory() async {
    return await apiClient.get(
      '/transactions', 
      includeXApiKey: true,
    );
  }
}