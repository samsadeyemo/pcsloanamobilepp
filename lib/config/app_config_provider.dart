// lib/config/app_config_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_config.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnv();
});
