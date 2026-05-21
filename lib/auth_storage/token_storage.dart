import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  // encryptedSharedPreferences is more resilient to reinstalls on Android
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // ─── Private helpers ──────────────────────────────────────────────────────

  bool _isDecryptionError(PlatformException e) {
    final msg = (e.message ?? '').toLowerCase();
    final details = (e.details?.toString() ?? '').toLowerCase();
    return msg.contains('bad_decrypt') ||
        msg.contains('badpaddingexception') ||
        details.contains('bad_decrypt') ||
        details.contains('badpaddingexception');
  }

  /// Wipes all stored tokens when decryption is no longer possible.
  /// The user will simply be asked to log in again.
  Future<void> _handleCorruptedStorage() async {
    try {
      await _storage.deleteAll();
    } catch (_) {
      // deleteAll itself can fail on badly corrupted state — try individually
      try { await _storage.delete(key: _accessTokenKey); } catch (_) {}
      try { await _storage.delete(key: _refreshTokenKey); } catch (_) {}
    }
  }

  Future<String?> _safeRead(String key) async {
    try {
      return await _storage.read(key: key);
    } on PlatformException catch (e) {
      if (_isDecryptionError(e)) {
        // Keystore key was invalidated (reinstall, backup-restore, OS upgrade).
        // Wipe the unreadable data so the next login can write fresh tokens.
        await _handleCorruptedStorage();
      }
      return null; // caller treats null as "not logged in"
    } catch (_) {
      return null;
    }
  }

  // ─── Public API ───────────────────────────────────────────────────────────

  Future<String?> getAccessToken() => _safeRead(_accessTokenKey);
  Future<String?> getRefreshToken() => _safeRead(_refreshTokenKey);

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }
}