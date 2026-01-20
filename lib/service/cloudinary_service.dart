import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:pcsloan/config/cloudinary_config.dart';

class CloudinaryService {
  

  CloudinaryService(this._config);
  final CloudinaryConfig _config;

  // Upload image to Cloudinary
  Future<String> uploadImage(File imageFile) async {
    try {
      // Generate timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Generate unique public_id
      final publicId = 'profile_pictures/${timestamp}_${imageFile.path.split('/').last.split('.').first}';
      
      // Create signature for signed upload
      final signature = _generateSignature(timestamp, publicId);
      
      // Prepare multipart request
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/${_config.cloudName}/image/upload'
      );
      
      final request = http.MultipartRequest('POST', url);
      
      // Add file
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path)
      );
      
      // Add parameters
      request.fields['public_id'] = publicId;
      request.fields['timestamp'] = timestamp;
      request.fields['api_key'] = _config.apiKey;
      request.fields['signature'] = signature;
      request.fields['folder'] = 'profile_pictures';
      
      // Send request
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseData);
        return jsonResponse['secure_url'] as String;
      } else {
        throw Exception('Failed to upload image: ${response.statusCode} - $responseData');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
  
  // Delete image from Cloudinary
  Future<bool> deleteImage(String imageUrl) async {
    try {
      // Extract public_id from URL
      final publicId = _extractPublicId(imageUrl);
      
      if (publicId.isEmpty) {
        throw Exception('Could not extract public_id from URL');
      }
      
      // Generate timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Create signature for deletion
      final signature = _generateDeleteSignature(timestamp, publicId);
      
      // Prepare request
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/${_config.cloudName}/image/destroy'
      );
      
      final response = await http.post(
        url,
        body: {
          'public_id': publicId,
          'timestamp': timestamp,
          'api_key': _config.apiKey,
          'signature': signature,
        },
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['result'] == 'ok';
      } else {
        throw Exception('Failed to delete image: ${response.statusCode}');
      }
    } catch (e) {
      return false;
    }
  }
  
  // Extract public_id from Cloudinary URL
  String _extractPublicId(String url) {
    try {
      // Example URL: https://res.cloudinary.com/cloud/image/upload/v1234567/profile_pictures/abc123.jpg
      
      // Split by /upload/
      final parts = url.split('/upload/');
      if (parts.length < 2) return '';
      
      // Get everything after /upload/
      final afterUpload = parts[1];
      
      // Remove version (v1234567/)
      final withoutVersion = afterUpload.replaceFirst(RegExp(r'v\d+/'), '');
      
      // Remove file extension
      final publicId = withoutVersion.replaceFirst(RegExp(r'\.[^.]+$'), '');
      
      return publicId;
    } catch (e) {
      return '';
    }
  }
  
  // Generate signature for upload
  String _generateSignature(String timestamp, String publicId) {
    final stringToSign = 'folder=profile_pictures&public_id=$publicId&timestamp=$timestamp${_config.apiSecret}';
    final bytes = utf8.encode(stringToSign);
    final digest = sha1.convert(bytes);
    return digest.toString();
  }
  
  // Generate signature for deletion
  String _generateDeleteSignature(String timestamp, String publicId) {
    final stringToSign = 'public_id=$publicId&timestamp=$timestamp${_config.apiSecret}';
    final bytes = utf8.encode(stringToSign);
    final digest = sha1.convert(bytes);
    return digest.toString();
  }
}