import 'package:flutter_dotenv/flutter_dotenv.dart';


class CloudinaryConfig {
  
  static String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  static  String apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? '';
  static  String apiSecret = dotenv.env['CLOUDINARY_API_SECRET'] ?? '';
  // We might need uploadPreset if using unsigned uploads
}