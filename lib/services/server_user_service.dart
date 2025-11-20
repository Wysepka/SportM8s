import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/io_client.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
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

      //TODO replace client with _serverService method for constistency
      //it need to be changed because the api endpoint prefix is confusing with other similar methods
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
      final response = await _serverService.getDynamicMap('user/agreement/$agreementName');
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

  Future<String> getUserProfileURL() async {
    try{
      final result = await _serverService.getDynamicMap("User/profileUrl");
      if(result.isNotEmpty){
        return result.entries.first.value;
      }
      else{
        return "https://i.sstatic.net/l60Hf.png";
      }
    }
    catch(error , stacktrace){
      _logger.error("There was an error while trying to get ProfileURL | E:$error ||| StackTrace:$stacktrace");
      return "https://i.sstatic.net/l60Hf.png";
    }
  }

  Future<bool> getChangeProfilePictureDisplayStatus() async{
    try{
      final result = await _serverService.getDynamicMap("User/profileDisplayChanged");
      if(result.isNotEmpty){
        return result["isProfileConfigurable"];
      }
      else{
        return false;
      }
    }
    catch(error , stacktrace){
      _logger.error("There was an error while trying to get ProfileDisplayChanged | E:$error ||| StackTrace:$stacktrace");
      return false;
    }
  }

  Future<String> getChangeProfileNameStatus() async{
    try{
      final result = await _serverService.getDynamicMap("User/profileName");
      if(result.isNotEmpty && result.entries.first.value != null){
        return result.entries.first.value;
      }
      else if(result.isNotEmpty && result.entries.first.value == null){
        return "Profile Name is null";
      }
      else{
        return "Error while loading data";
      }
    }
    catch(error , stacktrace){
      _logger.error("There was an error while trying to get getChangeProfileNameStatus | E:$error ||| StackTrace:$stacktrace");
      return "Error while loading data";
    }
  }

  Future<String> getChangeProfileSurnameStatus() async
  {
    try{
      final result = await _serverService.getDynamicMap("User/profileSurname");
      if(result.isNotEmpty && result.entries.first.value != null){
        return result.entries.first.value;
      }
      else if(result.isNotEmpty && result.entries.first.value == null){
        return "Profile Name is null";
      }
      else{
        return "Error while loading data";
      }
    }
    catch(error , stacktrace){
      _logger.error("There was an error while trying to get getChangeProfileSurnameStatus | E:$error ||| StackTrace:$stacktrace");
      return "Error while loading data";
    }
  }

  Future<String> getChangeProfileDisplayNameStatus() async
  {
    try{
      final result = await _serverService.getDynamicMap("User/profileDisplayName");
      if(result.isNotEmpty && result.entries.first.value != null){
        return result.entries.first.value;
      }
      else if(result.isNotEmpty && result.entries.first.value == null){
        return "Profile Name is null";
      }
      else{
        return "Error while loading data";
      }
    }
    catch(error , stacktrace){
      _logger.error("There was an error while trying to get getChangeProfileDisplayNameStatus | E:$error ||| StackTrace:$stacktrace");
      return "Error while loading data";
    }
  }

  Future<bool> setProfileDisplayParam(String value, ProfileDisplayPropertyType type) async {
    try{
      final typeString = type.name;
      final result = await _serverService.post("User/setProfileDisplayParam/$typeString" ,
        body: {
          'Value': value,
          'Type': typeString,
        },);
      int resultResponseCode = result['statusCode'];
      if(resultResponseCode == 200){
        _logger.info("Successfully updated ProfileDisplayParam with Value: $value with type: $type");
        return true;
      }
      else{
        _logger.error("Could not update ProfileDisplayParam with Value: $value with type: $type , response code: $resultResponseCode");
        return false;
      }
    }
    catch(e , stacktrace){
      _logger.error("There was an error while trying to get setProfileDisplayParam | E:$e  ||| StackTrace:$stacktrace");
      return false;
    }

  }
} 