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


  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  
}
