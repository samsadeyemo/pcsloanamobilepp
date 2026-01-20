// // lib/config/app_config.dart
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class AppConfig {
//   final String env;
//   final String apiBaseUrl;
//   final String xApiKey = dotenv.env['X_API_KEY'] ?? '';

//   AppConfig._(this.env, this.apiBaseUrl);

//   factory AppConfig.fromEnv() {
//     final env = dotenv.env['ENV'] ?? 'DEV';
//     final isProd = env.toUpperCase() == 'PROD';

//     final baseUrl = isProd
//         ? dotenv.env['API_PROD_URL']!
//         : dotenv.env['API_DEV_URL']!;

//     return AppConfig._(env, baseUrl);
//   }
// }

// final AppConfig appConfig = AppConfig.fromEnv();
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  final String env;
  final String apiBaseUrl;
  final String xApiKey;

  // Local-only secrets (never required in CI)
  final String cloudinaryCloudName;
  final String cloudinaryApiKey;
  final String cloudinaryApiSecret;

  const AppConfig._({
    required this.env,
    required this.apiBaseUrl,
    required this.xApiKey,
    required this.cloudinaryCloudName,
    required this.cloudinaryApiKey,
    required this.cloudinaryApiSecret,
  });

  factory AppConfig.fromEnv() {
    // 1️⃣ ENV
    const envFromDefine = String.fromEnvironment('ENV');
    final env = envFromDefine.isNotEmpty
        ? envFromDefine
        : dotenv.env['ENV'] ?? 'DEV';

    final isProd = env.toUpperCase() == 'PROD';

    print('🔍 Environment: $env (isProd: $isProd)');

    // 2️⃣ API BASE URL (dart-define → .env → fallback)
    const prodUrlFromDefine = String.fromEnvironment('API_PROD_URL');
    const devUrlFromDefine = String.fromEnvironment('API_DEV_URL');
    
    final prodUrlFromDotenv = dotenv.env['API_PROD_URL'];
    final devUrlFromDotenv = dotenv.env['API_DEV_URL'];

    print('🔍 dart-define PROD URL: ${prodUrlFromDefine.isEmpty ? "empty" : prodUrlFromDefine}');
    print('🔍 dart-define DEV URL: ${devUrlFromDefine.isEmpty ? "empty" : devUrlFromDefine}');
    print('🔍 .env PROD URL: ${prodUrlFromDotenv ?? "null"}');
    print('🔍 .env DEV URL: ${devUrlFromDotenv ?? "null"}');

    final apiBaseUrl = _pickValue(
      defineValue: isProd ? prodUrlFromDefine : devUrlFromDefine,
      dotenvValue: isProd ? prodUrlFromDotenv : devUrlFromDotenv,
      fallback: null,
    );

    if (apiBaseUrl == null || apiBaseUrl.isEmpty) {
      throw Exception(
        '❌ API base URL is not defined for ${isProd ? "PROD" : "DEV"}.\n'
        'Please provide it via:\n'
        '  • --dart-define=${isProd ? "API_PROD_URL" : "API_DEV_URL"}=<url>\n'
        '  • OR add ${isProd ? "API_PROD_URL" : "API_DEV_URL"} to your .env file',
      );
    }

    print('✅ Using API URL: $apiBaseUrl');

    // 3️⃣ X-API-KEY
    final xApiKey = _pickValue(
      defineValue: const String.fromEnvironment('X_API_KEY'),
      dotenvValue: dotenv.env['X_API_KEY'],
      fallback: '',
    );

    return AppConfig._(
      env: env,
      apiBaseUrl: apiBaseUrl,
      xApiKey: xApiKey ?? '',

      // 🔒 Local-only secrets (safe to be empty in CI)
      cloudinaryCloudName: dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '',
      cloudinaryApiKey: dotenv.env['CLOUDINARY_API_KEY'] ?? '',
      cloudinaryApiSecret: dotenv.env['CLOUDINARY_API_SECRET'] ?? '',
    );
  }

  static String? _pickValue({
    required String defineValue,
    required String? dotenvValue,
    String? fallback,
  }) {
    if (defineValue.isNotEmpty) return defineValue;
    if (dotenvValue != null && dotenvValue.isNotEmpty) return dotenvValue;
    return fallback;
  }
}