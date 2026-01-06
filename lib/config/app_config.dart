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

  const AppConfig._({
    required this.env,
    required this.apiBaseUrl,
    required this.xApiKey,
  });

  factory AppConfig.fromEnv() {
    // Priority: dart-define → .env → fallback
    final env =
        const String.fromEnvironment('ENV') ??
        dotenv.env['ENV'] ??
        'DEV';

    final isProd = env.toUpperCase() == 'PROD';

    final apiBaseUrl =
        (isProd
            ? const String.fromEnvironment('API_PROD_URL')
            : const String.fromEnvironment('API_DEV_URL'))
        .isNotEmpty
            ? (isProd
                ? const String.fromEnvironment('API_PROD_URL')
                : const String.fromEnvironment('API_DEV_URL'))
            : (isProd
                ? dotenv.env['API_PROD_URL']
                : dotenv.env['API_DEV_URL']);

    final xApiKey =
        const String.fromEnvironment('X_API_KEY').isNotEmpty
            ? const String.fromEnvironment('X_API_KEY')
            : dotenv.env['X_API_KEY'] ?? '';

    if (apiBaseUrl == null || apiBaseUrl.isEmpty) {
      throw Exception('API base URL is not defined');
    }

    return AppConfig._(
      env: env,
      apiBaseUrl: apiBaseUrl,
      xApiKey: xApiKey,
    );
  }
}

final appConfig = AppConfig.fromEnv();
