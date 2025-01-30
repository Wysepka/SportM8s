import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/io_client.dart';

class ServerService {
  static const bool isRunningLocally = false;
  
  String get baseUrl {
    if (isRunningLocally) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        // For physical Android device, use your computer's IP address
        return 'http://192.168.100.33:32774';  // Your actual Ethernet IP address with new port
      }
      return 'http://localhost:32774';
    } else {
      return 'https://sportm8s-server.politedune-52601b72.westeurope.azurecontainerapps.io';
    }
  }

  Future<void> testConnection() async {
    // Create a client that accepts all certificates in development
    final httpClient = HttpClient()
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => isRunningLocally);
    final client = IOClient(httpClient);

    try {
      print('Testing basic internet connectivity...');
      final googleResponse = await client.get(Uri.parse('https://google.com'));
      print('Google test: ${googleResponse.statusCode}');
      
      print('\nTesting server health check...');
      final healthResponse = await client.get(
        Uri.parse('$baseUrl/api/auth/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      print('Health check status: ${healthResponse.statusCode}');
      print('Health check body: ${healthResponse.body}');
      
      // Add more detailed error logging
      if (healthResponse.statusCode != 200) {
        print('Server responded with non-200 status code');
        print('Response headers: ${healthResponse.headers}');
      }
    } catch (e) {
      print('Connection test failed with error: $e');
      if (e is SocketException) {
        print('Socket error - likely cannot reach server. Check if server is running and port is correct');
      } else if (e is TimeoutException) {
        print('Request timed out - server might be slow or unreachable');
      }
    } finally {
      client.close();
    }
  }
  
  Future<bool> connectToServer() async {
    // Create a client that accepts all certificates in development
    final httpClient = HttpClient()
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => isRunningLocally);
    final client = IOClient(httpClient);

    try {
      print('\n=== Starting server connection attempt ===');
      print('Platform: ${defaultTargetPlatform.toString()}');
      print('Using URL: $baseUrl');
      
      // Test basic connectivity first
      await testConnection();
      
      // Get the current Firebase user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No Firebase user found');
        return false;
      }
      
      // Get the ID token
      final token = await user.getIdToken();
      print('Got Firebase token: ${token?.substring(0, math.min(10, token!.length))}...');
      
      final uri = Uri.parse('$baseUrl/api/auth/connect');
      print('Making request to: ${uri.toString()}');
      
      // Send initial request
      final response = await client.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('Request timed out after 10 seconds!');
          throw TimeoutException('Connection timed out');
        },
      );

      print('Response received!');
      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');

      // Add handling for 500 Internal Server Error
      if (response.statusCode == 500) {
        print('\n=== Server Error (500) Details ===');
        print('Server returned an internal error');
        print('Response body: ${response.body}');  // This might contain error details
        print('Request URL: ${uri.toString()}');
        print('Request headers: ${response.request?.headers}');
        
        // You might want to implement retry logic here
        // For now, we'll return false to indicate connection failure
        return false;
      }

      // Handle redirect manually
      if (response.statusCode == 307) {
        final redirectUrl = response.headers['location'];
        print('Response headers for 307: ${response.headers}');  // Add detailed header logging
        
        if (redirectUrl == null) {
          print('Warning: Received 307 status but no location header was present');
          // Try to continue with original response since no redirect URL was provided
          return response.statusCode == 200;
        }

        print('Following redirect to: $redirectUrl');
        final redirectResponse = await client.post(
          Uri.parse(redirectUrl),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ).timeout(const Duration(seconds: 10));
        
        print('Redirect response status: ${redirectResponse.statusCode}');
        print('Redirect response headers: ${redirectResponse.headers}');  // Add headers logging
        print('Redirect response body: ${redirectResponse.body}');
        
        return redirectResponse.statusCode == 200;
      }

      return response.statusCode == 200;
    } catch (e, stackTrace) {
      print('\n=== Error Details ===');
      print('Error connecting to server: $e');
      print('Stack trace: $stackTrace');
      return false;
    } finally {
      client.close();
    }
  }
} 