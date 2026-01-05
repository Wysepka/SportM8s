import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/io_client.dart';
import 'dart:convert';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/services/server_user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Add this provider at the top of the file, after imports
final serverServiceProvider = Provider((ref) {
  final httpClient = HttpClient()
    ..badCertificateCallback = ((X509Certificate cert, String host, int port) => ServerService.isRunningLocally);
  final client = IOClient(httpClient);
  
  return ServerService(client);
});

class ServerService {
  final LoggerService _logger = LoggerService();
  late final ServerUserService userService;
  static const bool isRunningLocally = true;
  //final String baseUrl;
  final IOClient _client;

  static bool get isEmulator {
    if (Platform.isAndroid) {
      return Platform.environment.containsKey('ANDROID_EMULATOR') || 
             Platform.environment.containsKey('ANDROID_SDK_ROOT');
    }
    if (Platform.isIOS) {
      return Platform.environment.containsKey('SIMULATOR_DEVICE_NAME');
    }
    return false;
  }

  static String get baseUrl {
    if (isRunningLocally) {
      // For Android
      if (Platform.isAndroid) {
        if (isEmulator) {
          return 'http://10.0.2.2:32771'; // Android emulator
        }
        //return 'http://192.168.33.11:44354'; // Physical Android device
        return 'http://192.168.33.14:32783'; // Physical Android device
      }
      // For iOS
      if (Platform.isIOS) {
        if (isEmulator) {
          return 'http://localhost:32771'; // iOS simulator
        }
        return 'http://192.168.100.33:32771'; // Physical iOS device
      }
      // Default to local network IP
      return 'http://192.168.100.33:32771';
    }
    // Production URL
    return 'https://sportm8s-server.politedune-52601b72.westeurope.azurecontainerapps.io';
  }

  ServerService(this._client) {
    userService = ServerUserService(this);
  }

  Future<void> testConnection() async {
    // Create a client that accepts all certificates in development
    final httpClient = HttpClient()
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => isRunningLocally);
    final client = IOClient(httpClient);

    try {
      _logger.info('Testing basic internet connectivity...');
      final googleResponse = await client.get(Uri.parse('https://google.com'));
      _logger.info('Google test: ${googleResponse.statusCode}');
      
      _logger.info('\nTesting server health check...');
      final healthResponse = await client.get(
        Uri.parse('$baseUrl/api/auth/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      _logger.info('Health check status: ${healthResponse.statusCode}');
      _logger.info('Health check body: ${healthResponse.body}');
      
      // Add more detailed error logging
      if (healthResponse.statusCode != 200) {
        _logger.error('Server responded with non-200 status code');
        _logger.debug('Response headers: ${healthResponse.headers}');
      }
    } catch (e) {
      _logger.error('Connection test failed with error: $e');
      if (e is SocketException) {
        _logger.error('Socket error - likely cannot reach server. Check if server is running and port is correct');
      } else if (e is TimeoutException) {
        _logger.error('Request timed out - server might be slow or unreachable');
      }
    } finally {
      client.close();
    }
  }
  
  Future<bool> connectToServer() async {
    final httpClient = HttpClient()
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => isRunningLocally);
    final client = IOClient(httpClient);

    try {
      _logger.info('=== Starting server connection attempt ===');
      _logger.info('Platform: ${defaultTargetPlatform.toString()}');
      _logger.info('Using URL: $baseUrl');
      
      // Test basic connectivity first
      await testConnection();
      
      // Get the current Firebase user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _logger.warning('No Firebase user found');
        return false;
      }
      
      // Get the ID token
      final token = await user.getIdToken();
      _logger.info('Got Firebase token: ${token?.substring(0, math.min(10, token!.length))}...');
      
      final uri = Uri.parse('$baseUrl/api/auth/connect');
      _logger.info('Making request to: ${uri.toString()}');
      
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
          _logger.error('Request timed out after 10 seconds!');
          throw TimeoutException('Connection timed out');
        },
      );

      _logger.info('Response received!');
      _logger.info('Response status code: ${response.statusCode}');
      _logger.debug('Response headers: ${response.headers}');

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          final isNewUser = responseData['isNewUser'] ?? false;

          if (isNewUser) {
            _logger.info('New user detected, updating user data...');
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await userService.updateUserData(user, client, token!);
            }
          }
        } catch (e) {
          _logger.error('Error parsing server response: $e');
          _logger.debug('Response body: ${response.body}');
          return false;
        }
      }

      // Add handling for 500 Internal Server Error
      if (response.statusCode == 500) {
        _logger.error('=== Server Error (500) Details ===');
        _logger.error('Server returned an internal error');
        _logger.error('Response body: ${response.body}');
        _logger.error('Request URL: ${uri.toString()}');
        _logger.debug('Request headers: ${response.request?.headers}');
        return false;
      }

      // Handle redirect manually
      if (response.statusCode == 307) {
        final redirectUrl = response.headers['location'];
        _logger.debug('Response headers for 307: ${response.headers}');
        
        if (redirectUrl == null) {
          _logger.warning('Received 307 status but no location header was present');
          return response.statusCode == 200;
        }

        _logger.info('Following redirect to: $redirectUrl');
        final redirectResponse = await client.post(
          Uri.parse(redirectUrl),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ).timeout(const Duration(seconds: 10));
        
        _logger.info('Redirect response status: ${redirectResponse.statusCode}');
        _logger.debug('Redirect response headers: ${redirectResponse.headers}');
        _logger.debug('Redirect response body: ${redirectResponse.body}');
        
        return redirectResponse.statusCode == 200;
      }

      return response.statusCode == 200;
    } catch (e, stackTrace) {
      _logger.error('=== Error Details ===');
      _logger.error('Error connecting to server: $e');
      _logger.error('Stack trace: $stackTrace');
      return false;
    } finally {
      client.close();
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final token = await user.getIdToken();
      _logger.debug('Making POST request to: ${ServerService.baseUrl}/api/$endpoint');
      final response = await _client.post(
        Uri.parse('$baseUrl/api/$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));

      _logger.debug('Response status code: ${response.statusCode}');
      if (response.statusCode == 401) {
        _logger.error('Authentication failed (401)');
        _logger.error('Response body: ${response.body}');
        throw HttpException('Authentication failed');
      }

      if (response.statusCode < 200 || response.statusCode > 299) {
        _logger.error('Request failed with status: ${response.statusCode}');
        _logger.error('Response body: ${response.body}');
        throw Exception('Failed to post data. Status: ${response.statusCode}. Body: ${response.body}');
      }

      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      _logger.error('Error in POST request to $endpoint: $e');
      rethrow;
    }
  }

  Future<dynamic> patch(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }
      
      final token = await user.getIdToken();
      _logger.debug('Making PATCH request to: ${ServerService.baseUrl}/api/$endpoint');

      final response = await _client.patch(
        Uri.parse('$baseUrl/api/$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));

      _logger.debug('Response status code: ${response.statusCode}');
      if (response.statusCode == 401) {
        _logger.error('Authentication failed (401)');
        _logger.error('Response body: ${response.body}');
        throw HttpException('Authentication failed');
      }

      if (response.statusCode < 200 || response.statusCode > 299) {
        _logger.error('Request failed with status: ${response.statusCode}');
        _logger.error('Response body: ${response.body}');
        throw Exception('Failed to patch data. Status: ${response.statusCode}. Body: ${response.body}');
      }

      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      _logger.error('Error in PATCH request to $endpoint: $e');
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final token = await user.getIdToken();
      _logger.debug('Making POST request to: ${ServerService.baseUrl}/api/$endpoint');
      final response = await _client.delete(
        Uri.parse('$baseUrl/api/$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));

      _logger.debug('Response status code: ${response.statusCode}');
      if (response.statusCode == 401) {
        _logger.error('Authentication failed (401)');
        _logger.error('Response body: ${response.body}');
        throw HttpException('Authentication failed');
      }

      if (response.statusCode < 200 || response.statusCode > 299) {
        _logger.error('Request failed with status: ${response.statusCode}');
        _logger.error('Response body: ${response.body}');
        throw Exception('Failed to post data. Status: ${response.statusCode}. Body: ${response.body}');
      }

      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      _logger.error('Error in POST request to $endpoint: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDynamicMap(String endpoint) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }
      
      // Add debug logging for token
      final token = await user.getIdToken();
      _logger.debug('Token details:');
      _logger.debug('Token length: ${token!.length}');
      _logger.debug('Token prefix: ${token.substring(0, math.min(50, token.length))}...');

      final url = '${ServerService.baseUrl}/api/$endpoint';
      _logger.debug('Making GET request to: $url');
      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      _logger.debug('Response status code: ${response.statusCode}');
      _logger.debug('Response headers: ${response.headers}');

      if (response.statusCode == 401) {
        _logger.error('Authentication failed (401)');
        _logger.error('Response body: ${response.body}');
        
        // Log the WWW-Authenticate header which contains the error details
        final wwwAuthenticate = response.headers['www-authenticate'];
        if (wwwAuthenticate != null) {
          _logger.error('Authentication error details: $wwwAuthenticate');
        }
        
        throw HttpException('Authentication failed: ${wwwAuthenticate ?? "Token issuer may be invalid"}');
      }

      if (response.statusCode != 200) {
        _logger.error('Request failed with status: ${response.statusCode}');
        _logger.error('Response body: ${response.body}');
        throw HttpException('Failed to get data. Status: ${response.statusCode}');
      }

      return jsonDecode(response.body);
    } catch (e) {
      _logger.error('Error in GET request to $endpoint: $e');
      if (e is HttpException) {
        rethrow;
      }
      throw HttpException('Failed to complete request: $e');
    }
  }

  Future<Map<String, dynamic>> getDynamicMapPaginated(String endpoint ,{ String? continuationToken , int pageSize = 50}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Add debug logging for token
      final token = await user.getIdToken();
      _logger.debug('Token details:');
      _logger.debug('Token length: ${token!.length}');
      _logger.debug('Token prefix: ${token.substring(0, math.min(50, token.length))}...');

      final url = '${ServerService.baseUrl}/api/$endpoint';
      _logger.debug('Making GET request to: $url');

      final response = await _client.get(
        Uri.parse(url).replace(
          queryParameters: {
            'pageSize': pageSize.toString(),
            if(continuationToken != null) 'continuationToken' : continuationToken,
          },
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      _logger.debug('Response status code: ${response.statusCode}');
      _logger.debug('Response headers: ${response.headers}');

      if (response.statusCode == 401) {
        _logger.error('Authentication failed (401)');
        _logger.error('Response body: ${response.body}');

        // Log the WWW-Authenticate header which contains the error details
        final wwwAuthenticate = response.headers['www-authenticate'];
        if (wwwAuthenticate != null) {
          _logger.error('Authentication error details: $wwwAuthenticate');
        }

        throw HttpException('Authentication failed: ${wwwAuthenticate ?? "Token issuer may be invalid"}');
      }

      if (response.statusCode != 200) {
        _logger.error('Request failed with status: ${response.statusCode}');
        _logger.error('Response body: ${response.body}');
        throw HttpException('Failed to get data. Status: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      final nextToken = data["x-ms-continuation"];

      return {
        'items' : data['items'],
        'continuationToken': nextToken ?? data['x-ms-continuation']
      };
    } catch (e) {
      _logger.error('Error in GET request to $endpoint: $e');
      if (e is HttpException) {
        rethrow;
      }
      throw HttpException('Failed to complete request: $e');
    }
  }

  Future<dynamic> getDynamicSimple(String endpoint) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Add debug logging for token
      final token = await user.getIdToken();
      _logger.debug('Token details:');
      _logger.debug('Token length: ${token!.length}');
      _logger.debug('Token prefix: ${token.substring(0, math.min(50, token.length))}...');

      final url = '${ServerService.baseUrl}/api/$endpoint';
      _logger.debug('Making GET request to: $url');

      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      _logger.debug('Response status code: ${response.statusCode}');
      _logger.debug('Response headers: ${response.headers}');

      if (response.statusCode == 401) {
        _logger.error('Authentication failed (401)');
        _logger.error('Response body: ${response.body}');

        // Log the WWW-Authenticate header which contains the error details
        final wwwAuthenticate = response.headers['www-authenticate'];
        if (wwwAuthenticate != null) {
          _logger.error('Authentication error details: $wwwAuthenticate');
        }

        throw HttpException('Authentication failed: ${wwwAuthenticate ?? "Token issuer may be invalid"}');
      }

      if (response.statusCode != 200) {
        _logger.error('Request failed with status: ${response.statusCode}');
        _logger.error('Response body: ${response.body}');
        throw HttpException('Failed to get data. Status: ${response.statusCode}');
      }

      return jsonDecode(response.body);
    } catch (e) {
      _logger.error('Error in GET request to $endpoint: $e');
      if (e is HttpException) {
        rethrow;
      }
      throw HttpException('Failed to complete request: $e');
    }
  }
} 