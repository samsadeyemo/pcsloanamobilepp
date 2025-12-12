import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pcsloan/auth_storage/token_storage.dart';
import 'package:pcsloan/config/app_config.dart';
import 'package:pcsloan/service/api_exception.dart';

class ApiClient {
  final AppConfig appConfig;
  final TokenStorage tokenStorage;
  final void Function() onAuthenticationFailed;

  // Track refresh state
  bool _isRefreshing = false;
  final List<Completer<void>> _failedQueue = [];

  ApiClient({
    required this.appConfig,
    required this.tokenStorage,
    required this.onAuthenticationFailed,
  });

  Uri _buildUrl(String path) {
    return Uri.parse('${appConfig.apiBaseUrl}$path');
  }

  Map<String, String> _buildHeaders({
    String? token,
    bool includeXApiKey = false,
  }) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (includeXApiKey && appConfig.xApiKey.isNotEmpty)
        'x-api-key': appConfig.xApiKey,
    };
    return headers;
  }

  void _processQueue({dynamic error}) {
    for (var completer in _failedQueue) {
      if (error != null) {
        completer.completeError(error);
      } else {
        completer.complete();
      }
    }
    _failedQueue.clear();
  }

  Future<void> _refreshToken() async {
    final refreshToken = await tokenStorage.getRefreshToken();

    if (refreshToken == null) {
      throw ApiException('No refresh token available');
    }

    final url = _buildUrl('/auth/refresh-token');
    final body = {'refresh_token': refreshToken};

    final response = await http
        .post(
          url,
          headers: _buildHeaders(
            includeXApiKey: true,
          ), // Include X-API-Key for refresh
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));

    final decoded = jsonDecode(response.body);

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        decoded['status'] == 'success') {
      // Save new tokens if present
      await _saveTokensIfPresent(decoded);
    } else {
      throw ApiException(decoded['message'] ?? 'Token refresh failed');
    }
  }

  Future<void> _saveTokensIfPresent(Map<String, dynamic> responseData) async {
    final data = responseData['data'];

    if (data != null && data is Map<String, dynamic>) {
      final accessToken = data['access_token'] ?? data['accessToken'];
      final refreshToken = data['refresh_token'] ?? data['refreshToken'];

      if (accessToken != null && refreshToken != null) {
        print("first condition was executed 👼");
        await tokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      } else if (accessToken != null) {
                print("second condition was executed 👼");

        await tokenStorage.saveAccessToken(accessToken);
      } else if (refreshToken != null) {
                print("third condition was executed 👼");

        await tokenStorage.saveRefreshToken(refreshToken);
      }
    }
  }

  Future<Map<String, dynamic>> _handleRequest(
    Future<http.Response> Function() request,
    String path,
  ) async {
    try {
      final response = await request();
      final decoded = jsonDecode(response.body);

      // Check if it's a 401 Unauthorized
      if (response.statusCode == 401 && !path.contains('/auth/refresh-token')) {
        // If already refreshing, queue this request
        if (_isRefreshing) {
          final completer = Completer<void>();
          _failedQueue.add(completer);

          try {
            await completer.future;
            // Retry the request after refresh completes
            return await _handleRequest(request, path);
          } catch (e) {
            onAuthenticationFailed();
            rethrow;
          }
        }

        // Start refresh process
        _isRefreshing = true;

        try {
          await _refreshToken();
          _processQueue();

          // Retry the original request
          return await _handleRequest(request, path);
        } catch (refreshError) {
          _processQueue(error: refreshError);
          await tokenStorage.clearTokens();
          onAuthenticationFailed();
          throw ApiException('Session expired. Please login again.');
        } finally {
          _isRefreshing = false;
        }
      }

      // Check for successful response
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          decoded['status'] == 'success') {
        // Save tokens if present in response
        await _saveTokensIfPresent(decoded);
        return decoded;
      } else {
        print(decoded);
        throw ApiException(decoded['message'] ?? 'Request failed');
      }
    } on TimeoutException {
      throw ApiException('Request timed out');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    bool includeXApiKey = false,
  }) async {
    return _handleRequest(() async {
      final token = await tokenStorage.getAccessToken();
      final url = _buildUrl(path);
      final headers = _buildHeaders(
        token: token,
        includeXApiKey: includeXApiKey,
      );

      return await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 15));
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
      final headers = _buildHeaders(
        token: token,
        includeXApiKey: includeXApiKey,
      );

      return await http
          .post(url, headers: headers, body: jsonEncode(body ?? {}))
          .timeout(const Duration(seconds: 15));
    }, path);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    bool includeXApiKey = false,
  }) async {
    return _handleRequest(() async {
      // 1. Retrieve the access token
      final token = await tokenStorage.getAccessToken();

      // 2. Build the full URL from the path
      final url = _buildUrl(path);

      // 3. Build the necessary headers (including Content-Type, Authorization, etc.)
      final headers = _buildHeaders(
        token: token,
        includeXApiKey: includeXApiKey,
      );

      // 4. Execute the HTTP PUT request
      return await http
          .put(
            url,
            headers: headers,
            body: jsonEncode(body ?? {}), // Encode the request body as JSON
          )
          .timeout(const Duration(seconds: 15)); // Apply a 15-second timeout
    }, path);
  }
}
