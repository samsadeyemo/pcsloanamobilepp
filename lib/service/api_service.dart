import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:flutter_riverpod/flutter_riverpod.dart'; // For Riverpod

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl); // Constructor
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'), // Login endpoint
      body: jsonEncode({'email': email, 'password': password}), // Request body
      headers: {'Content-Type': 'application/json'}, // JSON header
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Returns token and userId
    }
    throw Exception('Login failed: ${response.statusCode}'); // Throws error
  }
}
