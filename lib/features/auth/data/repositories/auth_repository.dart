//This file defines the AuthRepository for handling authentication data operations.
//Takes ApiService and SharedPreferences for API calls and persistence.


import 'dart:convert';
import 'package:pcsloan/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final ApiService apiService;
  final SharedPreferences prefs;

  AuthRepository(this.apiService, this.prefs);

  Future<Map<String, String>> login(String phoneNumber, String password) async {
    final response = await apiService.login(phoneNumber, password);
    final token = response['token'] as String;
    final userId = response['userId'] as String;

    await prefs.setString('token', token);
    await prefs.setString('userId', userId);

    return {'token': token, 'userId': userId};
  }

  void logout() {
    prefs.remove('token');
    prefs.remove('userId');
  }

  String? getToken() => prefs.getString('token');
  String? getUserId() => prefs.getString('userId');
}