import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _userKey = 'userData';


  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_userKey);
    if (jsonStr == null) return null;
    return jsonDecode(jsonStr);
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  static Future<void> setPhoneVerified(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('phone_verified', value);
}

  static Future<bool> isPhoneVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('phone_verified') ?? false;
  }

  static Future<void> setAccountCreated(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('account_created', value);
  }

  static Future<bool> isAccountCreated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('account_created') ?? false;
  }

  static Future<void> setPasswordCreated(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('password_created', value);
  }
  static Future<bool> isPasswordCreated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('password_created') ?? false;
  }
  static Future<void> setPinCreated(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pin_created', value);
  }
  static Future<bool> isPinCreated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('pin_created') ?? false;
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> setHasLoan(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_loan', value);
  }

  static Future<bool> hasLoan() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_loan') ?? false;
  }
  

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  
}
