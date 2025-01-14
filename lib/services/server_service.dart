import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ServerService {
  // Get base URL based on build mode
  String get baseUrl {
    if (kDebugMode) {
      // Local development
        return 'https://sportm8s-server.politedune-52601b72.westeurope.azurecontainerapps.io';
      //return 'https://localhost:8080';
    } else {
      // Production/Azure
      return 'https://sportm8s-server.politedune-52601b72.westeurope.azurecontainerapps.io';
    }
  }
  
  Future<bool> connectToServer() async {
    try {
      // Get the current Firebase user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;
      
      // Get the ID token
      final token = await user.getIdToken();
      
      print('Connecting to server at: $baseUrl'); // Debug log
      
      // Send request to your ASP.NET server
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/connect'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Successfully connected to server');
        return true;
      } else {
        print('Server error: Status ${response.statusCode}');
        print('Response body: ${response.body}');  // Add this line to see the error details
        return false;
      }
    } catch (e) {
      print('Error connecting to server: $e');
      return false;
    }
  }
} 