import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
     print("💾 Access token saved: ${token.substring(0, 20)}...");
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
        print("💾 Refresh token saved: ${token.substring(0, 20)}...");

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
    print("💾 saveTokens called");
    print("💾 Access token length: ${accessToken.length}");
    print("💾 Refresh token length: ${refreshToken.length}");
    
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
    
    // Verify tokens were actually saved
    final savedAccess = await getAccessToken();
    final savedRefresh = await getRefreshToken();
    
    print("✅ Verification after save:");
    print("   Access token exists: ${savedAccess != null}");
    print("   Refresh token exists: ${savedRefresh != null}");
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
    print("🔍 Getting access token: ${token != null ? 'EXISTS' : 'NULL'}");
    return token;
  }

  Future<String?> getRefreshToken() async {
    final token = await _storage.read(key: _refreshTokenKey);
    print("🔍 Getting refresh token: ${token != null ? 'EXISTS' : 'NULL'}");
    return token;
  }

  Future<void> clearTokens() async {
    print("🗑️ Clearing all tokens");
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
    print("🗑️ Tokens cleared");
  }

}
