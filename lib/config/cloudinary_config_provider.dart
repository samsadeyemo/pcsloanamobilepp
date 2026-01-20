import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_config_provider.dart';
import 'cloudinary_config.dart';

final cloudinaryConfigProvider = Provider<CloudinaryConfig>((ref) {
  final appConfig = ref.read(appConfigProvider);

  return CloudinaryConfig(
    cloudName: appConfig.cloudinaryCloudName,
    apiKey: appConfig.cloudinaryApiKey,
    apiSecret: appConfig.cloudinaryApiSecret,
  );
});
