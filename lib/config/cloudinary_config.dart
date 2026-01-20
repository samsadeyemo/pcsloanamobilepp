

// class CloudinaryConfig {
  
//   static String cloudName = appConfig.cloudinaryCloudName;
//   static  String apiKey = appConfig.cloudinaryApiKey;
//   static  String apiSecret = appConfig.cloudinaryApiSecret;
//   // We might need uploadPreset if using unsigned uploads
// }


class CloudinaryConfig {
  final String cloudName;
  final String apiKey;
  final String apiSecret;

  const CloudinaryConfig({
    required this.cloudName,
    required this.apiKey,
    required this.apiSecret,
  });
}
