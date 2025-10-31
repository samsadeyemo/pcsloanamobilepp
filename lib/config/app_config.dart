// lib/config/app_config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  final String env;
  final String apiBaseUrl;
  final String xApiKey = dotenv.env['X_API_KEY'] ?? '';

  AppConfig._(this.env, this.apiBaseUrl);

  factory AppConfig.fromEnv() {
    final env = dotenv.env['ENV'] ?? 'DEV';
    final isProd = env.toUpperCase() == 'PROD';

    final baseUrl = isProd
        ? dotenv.env['API_PROD_URL']!
        : dotenv.env['API_DEV_URL']!;

    return AppConfig._(env, baseUrl);
  }
}

final AppConfig appConfig = AppConfig.fromEnv();
