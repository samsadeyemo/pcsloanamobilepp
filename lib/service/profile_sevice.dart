import 'package:pcsloan/config/app_config.dart';
import 'package:pcsloan/main.dart';

class ProfileService {
  final String baseUrl = appConfig.apiBaseUrl;

  Future<Map<String, dynamic>> fetchUserProfile() async {
    return await apiClient.get('/users/profile');
  }

  Future<Map<String, dynamic>> editUserProfilePicture({
    required String imageUrl,
  }) async {
    return await apiClient.put(
      '/users',
      body: {'profile_picture': imageUrl},
      includeXApiKey: true,
    );
  }

  Future<Map<String, dynamic>> editUserEmail({
    required String emailAddress,
  }) async {
    return await apiClient.put(
      '/users',
      body: {'email': emailAddress},
      includeXApiKey: true,
    );
  }

  
}
