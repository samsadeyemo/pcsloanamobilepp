// import 'dart:convert';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'package:pcsloan/auth_storage/token_storage.dart';
// import 'package:pcsloan/config/app_config.dart';
// import 'package:pcsloan/service/api_exception.dart';

// class ApiClient {
//   final AppConfig appConfig;
//   final TokenStorage tokenStorage;
//   final void Function() onAuthenticationFailed;

//   // Track refresh state
//   bool _isRefreshing = false;
//   final List<Completer<void>> _failedQueue = [];

//   ApiClient({
//     required this.appConfig,
//     required this.tokenStorage,
//     required this.onAuthenticationFailed,
//   });

//   Uri _buildUrl(String path) {
//     return Uri.parse('${appConfig.apiBaseUrl}$path');
//   }

//   String _parseMessage(dynamic message, [String fallback = 'Request failed']) {
//   if (message == null) return fallback;
//   if (message is String) return message;
//   if (message is List) return message.join(', ');
//   return message.toString();
// }

//   Map<String, String> _buildHeaders({
//     String? token,
//     bool includeXApiKey = false,
//   }) {
//     final headers = <String, String>{
//       'Content-Type': 'application/json',
//       if (token != null) 'Authorization': 'Bearer $token',
//       if (includeXApiKey && appConfig.xApiKey.isNotEmpty)
//         'x-api-key': appConfig.xApiKey,
//     };
//     return headers;
//   }

//   void _processQueue({dynamic error}) {
//     for (var completer in _failedQueue) {
//       if (error != null) {
//         completer.completeError(error);
//       } else {
//         completer.complete();
//       }
//     }
//     _failedQueue.clear();
//   }

//   Future<void> _refreshToken() async {
//     final refreshToken = await tokenStorage.getRefreshToken();

//     if (refreshToken == null) {
//       throw ApiException('No refresh token available');
//     }

//     final url = _buildUrl('/auth/refresh-token');
//     final body = {'refresh_token': refreshToken};

//     final response = await http
//         .post(
//           url,
//           headers: _buildHeaders(
//             includeXApiKey: true,
//           ), // Include X-API-Key for refresh
//           body: jsonEncode(body),
//         )
//         .timeout(const Duration(seconds: 30));

//     final decoded = jsonDecode(response.body);

//     if ((response.statusCode == 200 || response.statusCode == 201) &&
//         decoded['status'] == 'success') {
//       // Save new tokens if present
//       await _saveTokensIfPresent(decoded);
//     } else {
//       throw ApiException(_parseMessage(decoded['message'], 'Token refresh failed'));
//     }
//   }

//   Future<void> _saveTokensIfPresent(Map<String, dynamic> responseData) async {
//     final data = responseData['data'];

//     if (data != null && data is Map<String, dynamic>) {
//       final accessToken = data['access_token'] ?? data['accessToken'];
//       final refreshToken = data['refresh_token'] ?? data['refreshToken'];

//       if (accessToken != null && refreshToken != null) {
//         print("first condition was executed 👼");
//         await tokenStorage.saveTokens(
//           accessToken: accessToken,
//           refreshToken: refreshToken,
//         );
//       } else if (accessToken != null) {
//         print("second condition was executed 👼");

//         await tokenStorage.saveAccessToken(accessToken);
//       } else if (refreshToken != null) {
//         print("third condition was executed 👼");

//         await tokenStorage.saveRefreshToken(refreshToken);
//       }
//     }
//   }

// // Future<Map<String, dynamic>> _handleRequest(
// //     Future<http.Response> Function() request,
// //     String path,
// //   ) async {
// //     try {
// //       final response = await request();
// //       final decoded = jsonDecode(response.body);
// //       print('API Response for $path: $decoded');

// //       // Check if it's a 401 Unauthorized
// //       if (response.statusCode == 401 && !path.contains('/auth/refresh-token')) {
// //         // If already refreshing, queue this request
// //         if (_isRefreshing) {
// //           final completer = Completer<void>();
// //           _failedQueue.add(completer);

// //           try {
// //             await completer.future;
// //             return await _handleRequest(request, path);
// //           } catch (e) {
// //             rethrow;
// //           }
// //         }

// //         // Start refresh process
// //         _isRefreshing = true;

// //         try {
// //           await _refreshToken();
// //           _processQueue();
// //           return await _handleRequest(request, path);
// //         } catch (refreshError) {
// //           _processQueue(error: refreshError);
// //           onAuthenticationFailed();
// //           // Don't throw — navigation is already happening,
// //           // throwing just causes the calling screen to show an error mid-transition
// //           return {'status': 'unauthenticated', 'data': null};
// //         } finally {
// //           _isRefreshing = false;
// //         }
// //       }

// //       // Check for successful response
// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         final status = decoded['status'];

// //         if (status == true || status == 'success') {
// //           await _saveTokensIfPresent(decoded);
// //           return decoded;
// //         } else {
// //           throw ApiException(_parseMessage(decoded['message']));
// //         }
// //       } else {
// //         throw ApiException(_parseMessage(decoded['message'], 'Request failed'));
// //       }
// //     } on TimeoutException {
// //       throw ApiException('Request timed out');
// //     } catch (e) {
// //       if (e is ApiException) rethrow;
// //       throw ApiException('Network error: $e');
// //     }
// //   }



//   Future<Map<String, dynamic>> get(
//     String path, {
//     bool includeXApiKey = false,
//   }) async {
//     return _handleRequest(() async {
//       final token = await tokenStorage.getAccessToken();
//       final url = _buildUrl(path);
//       final headers = _buildHeaders(
//         token: token,
//         includeXApiKey: includeXApiKey,
//       );

//       return await http
//           .get(url, headers: headers)
//           .timeout(const Duration(seconds: 30));
//     }, path);
//   }

//   Future<Map<String, dynamic>> post(
//     String path, {
//     Map<String, dynamic>? body,
//     bool includeXApiKey = false,
//   }) async {
//     return _handleRequest(() async {
//       final token = await tokenStorage.getAccessToken();
//       final url = _buildUrl(path);
//       final headers = _buildHeaders(
//         token: token,
//         includeXApiKey: includeXApiKey,
//       );
//       print('Making POST request to $url with body: $body and headers: $headers');
//       return await http
//           .post(url, headers: headers, body: jsonEncode(body ?? {}))
//           .timeout(const Duration(seconds: 30));
//     }, path);
//   }

//   Future<Map<String, dynamic>> put(
//     String path, {
//     Map<String, dynamic>? body,
//     bool includeXApiKey = false,
//   }) async {
//     return _handleRequest(() async {
//       // 1. Retrieve the access token
//       final token = await tokenStorage.getAccessToken();

//       // 2. Build the full URL from the path
//       final url = _buildUrl(path);

//       // 3. Build the necessary headers (including Content-Type, Authorization, etc.)
//       final headers = _buildHeaders(
//         token: token,
//         includeXApiKey: includeXApiKey,
//       );

//       // 4. Execute the HTTP PUT request
//       return await http
//           .put(
//             url,
//             headers: headers,
//             body: jsonEncode(body ?? {}), // Encode the request body as JSON
//           )
//           .timeout(const Duration(seconds: 30)); // Apply a 15-second timeout
//     }, path);
//   }


  
// Future<List<dynamic>> getList(
//   String path, {
//   bool includeXApiKey = false,
// }) async {
//   Future<http.Response> makeRequest() async {
//     final token = await tokenStorage.getAccessToken();
//     final url = _buildUrl(path);
//     final headers = _buildHeaders(
//       token: token,
//       includeXApiKey: includeXApiKey,
//     );
//     return await http
//         .get(url, headers: headers)
//         .timeout(const Duration(seconds: 30));
//   }

//   try {
//     var response = await makeRequest();

//     // 401 handling + token refresh
//     if (response.statusCode == 401) {
//       try {
//         await _refreshToken();
//       } catch (_) {
//         onAuthenticationFailed();
//         return [];
//       }
//       // Retry once with the new token
//       response = await makeRequest();
//     }

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final decoded = jsonDecode(response.body);
//       if (decoded is List) return decoded;
//       throw ApiException('Expected List response but got ${decoded.runtimeType}');
//     } else {
//       throw ApiException('Request failed with status: ${response.statusCode}');
//     }
//   } on TimeoutException {
//     throw ApiException('Request timed out');
//   } catch (e) {
//     if (e is ApiException) rethrow;
//     throw ApiException('Network error: $e');
//   }
// }
// }


import 'dart:convert';
import 'dart:async';
import 'dart:io'; // ← ADD THIS
import 'package:http/http.dart' as http;
import 'package:pcsloan/auth_storage/token_storage.dart';
import 'package:pcsloan/config/app_config.dart';
import 'package:pcsloan/service/api_exception.dart';

class ApiClient {
  final AppConfig appConfig;
  final TokenStorage tokenStorage;
  final void Function() onAuthenticationFailed;

  // In-flight refresh, shared so concurrent callers never send the same
  // refresh token twice (a rotated token would make the second call fail).
  Future<Map<String, dynamic>>? _refreshFuture;

  // ─── Retry config ────────────────────────────────────────────
  static const int _maxRetries = 3;
  static const Duration _retryBaseDelay = Duration(seconds: 2);
  // ─────────────────────────────────────────────────────────────

  ApiClient({
    required this.appConfig,
    required this.tokenStorage,
    required this.onAuthenticationFailed,
  });

  Uri _buildUrl(String path) =>
      Uri.parse('${appConfig.apiBaseUrl}$path');

  String _parseMessage(dynamic message,
      [String fallback = 'Request failed']) {
    if (message == null) return fallback;
    if (message is String) return message;
    if (message is List) return message.join(', ');
    return message.toString();
  }

  Map<String, String> _buildHeaders({
    String? token,
    bool includeXApiKey = false,
  }) {
    return <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (includeXApiKey && appConfig.xApiKey.isNotEmpty)
        'x-api-key': appConfig.xApiKey,
    };
  }

  bool _isSuccess(http.Response response, dynamic decoded) {
    if (response.statusCode != 200 && response.statusCode != 201) return false;
    if (decoded is! Map) return false;
    final status = decoded['status'];
    return status == true || status == 'success';
  }

  // ─── NEW: Check if an error is a retryable network-level error ───
  bool _isNetworkError(dynamic e) {
    if (e is SocketException) return true;
    if (e is TimeoutException) return true;
    if (e is HttpException) return true;
    if (e is http.ClientException) return true;
    // Covers the raw string your error was showing
    final msg = e.toString().toLowerCase();
    return msg.contains('failed host lookup') ||
        msg.contains('socketexception') ||
        msg.contains('network is unreachable') ||
        msg.contains('connection refused')||
        msg.contains('connection closed before full header'); 
  }

  // ─── NEW: Retry wrapper with exponential backoff ─────────────────
  Future<http.Response> _executeWithRetry(
    Future<http.Response> Function() request,
  ) async {
    int attempt = 0;
    while (true) {
      try {
        return await request();
      } catch (e) {
        attempt++;
        if (_isNetworkError(e) && attempt < _maxRetries) {
          // Exponential backoff: 2s, 4s, 6s...
          final delay = _retryBaseDelay * attempt;
          print('Network error (attempt $attempt/$_maxRetries). '
              'Retrying in ${delay.inSeconds}s... Error: $e');
          await Future.delayed(delay);
          continue;
        }
        rethrow; // Give up after max retries
      }
    }
  }

  /// Exchanges the stored refresh token for new tokens and saves them.
  /// Returns the response `data` map (may contain `user`, `hasLoan`, ...).
  ///
  /// Throws [SessionExpiredException] when the refresh token is missing or
  /// rejected, and [ApiException] for network/server problems (retryable).
  Future<Map<String, dynamic>> refreshSession() {
    return _refreshFuture ??=
        _refreshToken().whenComplete(() => _refreshFuture = null);
  }

  Future<Map<String, dynamic>> _refreshToken() async {
    final refreshToken = await tokenStorage.getRefreshToken();
    if (refreshToken == null) throw SessionExpiredException();
    // The backend expects the (possibly expired) access token alongside
    // the refresh token, so send it like any other request.
    final accessToken = await tokenStorage.getAccessToken();

    final http.Response response;
    try {
      response = await _executeWithRetry(
        () => http
            .post(
              _buildUrl('/auth/refresh-token'),
              headers: _buildHeaders(token: accessToken, includeXApiKey: true),
              body: jsonEncode({'refresh_token': refreshToken}),
            )
            .timeout(const Duration(seconds: 60)),
      );
    } catch (e) {
      throw ApiException(
          'Could not reach the server. Please check your network and try again.');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      decoded = null;
    }

    if (_isSuccess(response, decoded)) {
      await _saveTokensIfPresent(decoded);
      final data = decoded['data'];
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    }

    print('Token refresh failed (${response.statusCode}): ${response.body}');

    if (response.statusCode >= 500) {
      throw ApiException('Server error. Please try again shortly.');
    }

    throw SessionExpiredException();
  }

  /// Returns the first value under [keys] that is shaped like a JWT.
  /// Some responses carry the user record, whose `refresh_token` is the
  /// server's bcrypt hash (`$2b$...`); saving that would break refresh.
  static String? _jwtFrom(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.split('.').length == 3) return value;
    }
    return null;
  }

  Future<void> _saveTokensIfPresent(
      Map<String, dynamic> responseData) async {
    final data = responseData['data'];
    if (data == null || data is! Map<String, dynamic>) return;

    final accessToken = _jwtFrom(data, ['access_token', 'accessToken']);
    final refreshToken = _jwtFrom(data, ['refresh_token', 'refreshToken']);

    if (accessToken != null && refreshToken != null) {
      await tokenStorage.saveTokens(
          accessToken: accessToken, refreshToken: refreshToken);
    } else if (accessToken != null) {
      await tokenStorage.saveAccessToken(accessToken);
    } else if (refreshToken != null) {
      await tokenStorage.saveRefreshToken(refreshToken);
    }
  }

  Future<Map<String, dynamic>> _handleRequest(
    Future<http.Response> Function() request,
    String path, {
    bool isRetry = false,
  }) async {
    try {
      // ↓ All requests now go through the retry wrapper
      final response = await _executeWithRetry(request);

      // Only retry once after a refresh, so a server that keeps answering
      // 401 can't trap us in a refresh loop.
      if (response.statusCode == 401 && !isRetry && path != '/auth/login') {
        try {
          await refreshSession();
        } on SessionExpiredException {
          onAuthenticationFailed();
          return {'status': 'unauthenticated', 'data': null};
        }
        return await _handleRequest(request, path, isRetry: true);
      }

      final decoded = jsonDecode(response.body);
      print('API Response for $path: $decoded');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (_isSuccess(response, decoded)) {
          await _saveTokensIfPresent(decoded);
          return decoded;
        } else {
          throw ApiException(_parseMessage(decoded['message']));
        }
      } else {
        throw ApiException(
            _parseMessage(decoded['message'], 'Request failed'));
      }
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on SocketException {
      // Reached only after all retries exhausted
      throw ApiException(
          'No internet connection. Please check your network.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> get(String path,
      {bool includeXApiKey = false}) async {
    return _handleRequest(() async {
      final token = await tokenStorage.getAccessToken();
      return await http
          .get(_buildUrl(path),
              headers: _buildHeaders(
                  token: token, includeXApiKey: includeXApiKey))
          .timeout(const Duration(seconds: 60));
    }, path);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool includeXApiKey = false,
  }) async {
    return _handleRequest(() async {
      final token = await tokenStorage.getAccessToken();
      final url = _buildUrl(path);
      final headers =
          _buildHeaders(token: token, includeXApiKey: includeXApiKey);
      print('POST → $url | body: $body');
      return await http
          .post(url, headers: headers, body: jsonEncode(body ?? {}))
          .timeout(const Duration(seconds: 60));
    }, path);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    bool includeXApiKey = false,
  }) async {
    return _handleRequest(() async {
      final token = await tokenStorage.getAccessToken();
      return await http
          .put(_buildUrl(path),
              headers: _buildHeaders(
                  token: token, includeXApiKey: includeXApiKey),
              body: jsonEncode(body ?? {}))
          .timeout(const Duration(seconds: 60));
    }, path);
  }

  // ─── FIXED: Now uses _handleRequest instead of duplicate logic ───
  Future<List<dynamic>> getList(
  String path, {
  bool includeXApiKey = false,
}) async {
  Future<http.Response> makeRequest() async {
    final token = await tokenStorage.getAccessToken();
    final url = _buildUrl(path);
    final headers = _buildHeaders(
      token: token,
      includeXApiKey: includeXApiKey,
    );
    return await _executeWithRetry( // ← only change: wrap with retry
      () => http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 60)),
    );
  }

  try {
    var response = await makeRequest();

    if (response.statusCode == 401) {
      try {
        await refreshSession();
      } on SessionExpiredException {
        onAuthenticationFailed();
        return [];
      }
      response = await makeRequest();
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) return decoded;
      throw ApiException('Expected List response but got ${decoded.runtimeType}');
    } else {
      throw ApiException('Request failed with status: ${response.statusCode}');
    }
  } on TimeoutException {
    throw ApiException('Request timed out');
  } on SocketException {
    throw ApiException('No internet connection. Please check your network.');
  } catch (e) {
    if (e is ApiException) rethrow;
    throw ApiException('Network error: $e');
  }
}
}
