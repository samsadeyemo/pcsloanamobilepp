

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/config/cloudinary_config_provider.dart';
import 'package:pcsloan/service/cloudinary_service.dart';

final cloudinaryServiceProvider = Provider<CloudinaryService>((ref) {
  final config = ref.read(cloudinaryConfigProvider);
  return CloudinaryService(config);
});
