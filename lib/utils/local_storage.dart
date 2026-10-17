import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _userKey = 'userData';
  static const _lastPhoneKey = 'last_phone';

  // SharedPreferences is a plain file (and part of device backups), so only
  // the fields the UI actually shows are kept. Never BVN / bank details.
  static const _userFields = [
    'id',
    'first_name',
    'last_name',
    'full_name',
    'email',
    'phone',
    'employee_id',
    'profile_picture',
  ];

  /// Saves the user in one flat shape. Accepts either the user map itself
  /// or a response `data` map that wraps it as `{user: {...}}`.
  static Future<void> saveUser(Map<String, dynamic>? raw) async {
    if (raw == null) return;
    final source = raw['user'] is Map<String, dynamic>
        ? raw['user'] as Map<String, dynamic>
        : raw;
    final user = {
      for (final key in _userFields)
        if (source[key] != null) key: source[key],
    };

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
    if (user['phone'] is String) {
      await prefs.setString(_lastPhoneKey, user['phone']);
    }
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_userKey);
    if (jsonStr == null) return null;
    return jsonDecode(jsonStr);
  }

  /// Phone of the last user, kept across logout to prefill the login form.
  static Future<String?> getLastPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastPhoneKey);
  }

  /// Clears personal data on logout. Keeps the last phone number and the
  /// device-level onboarding / sign-up progress flags.
  static Future<void> clearOnLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_userKey),
      prefs.remove('has_loan'),
      prefs.remove('biometric_enabled'),
      prefs.remove('has_login_before'),
    ]);
  }

  /// One-off cleanup for data written by older app versions: a plain-text
  /// access token, and user records saved with BVN / bank details.
  static Future<void> migrate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    final user = await getUser();
    if (user != null) await saveUser(user);
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

  static Future<void> setHasLoginBefore(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_login_before', value);
  }

  static Future<bool> hasLoginBefore() async{
   final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_login_before') ?? false; 
  }

  static Future<void> setBiometricEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', value);
  }

  static Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('biometric_enabled') ?? false;
  }
}
