import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/io_client.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/server_response.dart';
import './server_service.dart';
import 'package:sportm8s/core/logger/logger_config.dart';

final serverUserServiceProvider = Provider((ref) {
  final serverService = ref.read(serverServiceProvider);
  return ServerUserService(serverService);
});

class ServerUserService {
  final LoggerService _logger = LoggerService();
  final ServerService _serverService;

  ServerUserService(this._serverService);

  Future<void> updateUserData(User user, IOClient client, String token) async {
    try {
      final userData = {
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      final response = await client.post(
        Uri.parse('${ServerService.baseUrl}/api/user/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        _logger.error('Failed to update user data. Status: ${response.statusCode}');
        _logger.error('Response body: ${response.body}');
      } else {
        _logger.info('User data successfully updated');
      }
    } catch (e) {
      _logger.error('Error updating user data: $e');
    }
  }

  Future<void> updateAgreement({
    required String agreementName,
    required DateTime acceptedAt,
  }) async {
    try {
      await _serverService.post(
        'User/agreements',
        body: {
          'agreementName': agreementName,
          'acceptedAt': acceptedAt.toIso8601String(),
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetAllAgreements() async{
    try {
      await _serverService.post(
        'User/agreementsReset',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkAgreementStatus(String agreementName) async {
    try {
      final response = await _serverService.get('user/agreement/$agreementName');
      return response['isAccepted'] ?? false;
    } catch (e) {
      _logger.error('Error checking agreement status: $agreementName', e);
      return false;
    }
  }

  Future<ServerResponse> updateUserAgreements({
    required bool termsAccepted,
    required bool privacyAccepted,
    required bool marketingAccepted,
  }) async {
    try {
      LoggerConfig.logger.i('Preparing to send agreements update to server', error: {
        'termsAccepted': termsAccepted,
        'privacyAccepted': privacyAccepted,
        'marketingAccepted': marketingAccepted,
      });

      final response = await _serverService.post(
        '/api/user/agreements',
        body: {
          'termsAccepted': termsAccepted,
          'privacyAccepted': privacyAccepted,
          'marketingAccepted': marketingAccepted,
        },
      );

      LoggerConfig.logger.i('Server response for agreements update', error: {
        'statusCode': response.statusCode,
        'body': response.body,
      });

      if (response.statusCode == 200) {
        LoggerConfig.logger.i('Agreements update successful');
        return ServerResponse(isSuccess: true);
      } else {
        LoggerConfig.logger.e('Server returned error status code', error: {
          'statusCode': response.statusCode,
          'body': response.body,
        });
        return ServerResponse(
          isSuccess: false,
          error: 'Failed to update agreements: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      LoggerConfig.logger.e('Exception while updating agreements', error: e, stackTrace: stackTrace);
      return ServerResponse(
        isSuccess: false,
        error: 'Error updating agreements: ${e.toString()}',
      );
    }
  }
} 