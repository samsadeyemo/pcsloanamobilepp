import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);

  }

  

  // Future<void> saveTokens({
  //   required String accessToken,
  //   required String refreshToken,
  // }) async {
  //   await Future.wait([
  //     saveAccessToken(accessToken),
  //     saveRefreshToken(refreshToken),
  //   ]);
  //   print("another refresh or login was called");
  // }

Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
    
    // Verify tokens were actually saved
    final savedAccess = await getAccessToken();
    final savedRefresh = await getRefreshToken();
    
  }


  // Future<String?> getAccessToken() async {
  //   return await _storage.read(key: _accessTokenKey);
  // }

  // Future<String?> getRefreshToken() async {
  //   return await _storage.read(key: _refreshTokenKey);
  // }

  // Future<void> clearTokens() async {
  //   await Future.wait([
  //     _storage.delete(key: _accessTokenKey),
  //     _storage.delete(key: _refreshTokenKey),
  //   ]);
  // }

  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: _accessTokenKey);
    return token;
  }

  Future<String?> getRefreshToken() async {
    final token = await _storage.read(key: _refreshTokenKey);
    return token;
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }

}
