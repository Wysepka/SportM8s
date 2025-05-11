import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logger/logger_config.dart';
import '../../services/server_user_service.dart';
import '../logger/logger_service.dart';

// Create a provider for agreement updates
final agreementUpdateProvider = Provider((ref) => AgreementUpdateNotifier(ref));

class AgreementUpdateNotifier {
  final Ref ref;

  AgreementUpdateNotifier(this.ref);

  Future<void> notifyAgreementAccepted(String agreementName) async {
    final serverUserService = ref.read(serverUserServiceProvider);
    try {
      await serverUserService.updateAgreement(
        agreementName: agreementName,
        acceptedAt: DateTime.now().toUtc(),
      );
    } catch (e) {
      // Handle or rethrow error as needed
      rethrow;
    }
  }

  Future<void> notifyAllAgreementsReset() async{
    final serverUserService = ref.read(serverUserServiceProvider);
    try {
      await serverUserService.resetAllAgreements();
    } catch (e) {
      // Handle or rethrow error as needed
      rethrow;
    }
  }
}

final storageServiceInitializerProvider = FutureProvider<StorageService>((ref) async {
  return await StorageService.getInstance();
});

class StorageService
{
  final LoggerService _logger = LoggerService();

  static const String PrivacyPolicyKey = "PrivacyPolicyAccepted";
  static const String TermsOfServiceKey = "TermsOfServiceAccepted";
  static const String EndUserLicenseKey = "EndUserLicenseAccepted";
  static const String DataCollectionConsentKey = "DataCollectionConsentAccepted";
  static const String ProfileDisplayChanged = "ProfileDisplayChanged";

  static StorageService? _storageService;
  static SharedPreferences? _sharedPreferences;

  static Future<StorageService> getInstance() async {
    _storageService ??= StorageService._();
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _storageService!;
  }

  StorageService._();

  Future<bool> _getAgreementStatus(WidgetRef ref, String agreementKey) async {
    final localStatus = _sharedPreferences?.getBool(agreementKey) ?? false;
    if (!localStatus) return false;

    try {
      final serverUserService = ref.read(serverUserServiceProvider);
      final serverStatus = await serverUserService.checkAgreementStatus(agreementKey);
      return serverStatus;
    } catch (e) {
      _logger.error('Error checking server agreement status for $agreementKey', e);
      return localStatus;
    }
  }

  Future<bool> hasPrivacyPolicyAccepted(WidgetRef ref) async =>
      await _getAgreementStatus(ref, PrivacyPolicyKey);

  Future<bool> hasTermsOfServiceAccepted(WidgetRef ref) async =>
      await _getAgreementStatus(ref, TermsOfServiceKey);

  Future<bool> hasEndUserLicenseAccepted(WidgetRef ref) async =>
      await _getAgreementStatus(ref, EndUserLicenseKey);

  Future<bool> hasDataCollectionConsentAccepted(WidgetRef ref) async =>
      await _getAgreementStatus(ref, DataCollectionConsentKey);

  Future<bool> setPrivacyPolicyAccepted(WidgetRef ref, bool value) async {
    final result = await _sharedPreferences?.setBool(PrivacyPolicyKey, value);
    if (value && result == true) {
      try {
        await ref.read(agreementUpdateProvider).notifyAgreementAccepted(PrivacyPolicyKey);
      } catch (e) {
        _logger.error('Error updating privacy policy agreement on server', e);
      }
    }
    return result ?? false;
  }

  Future<bool> setTermsOfServiceAccepted(WidgetRef ref, bool value) async {
    final result = await _sharedPreferences?.setBool(TermsOfServiceKey, value);
    if (value && result == true) {
      try {
        await ref.read(agreementUpdateProvider).notifyAgreementAccepted(TermsOfServiceKey);
      } catch (e) {
        _logger.error('Error updating terms of service agreement on server', e);
      }
    }
    return result ?? false;
  }

  Future<bool> setEndUserLicenseAccepted(WidgetRef ref, bool value) async {
    final result = await _sharedPreferences?.setBool(EndUserLicenseKey, value);
    if (value && result == true) {
      try {
        await ref.read(agreementUpdateProvider).notifyAgreementAccepted(EndUserLicenseKey);
      } catch (e) {
        _logger.error('Error updating end user license agreement on server', e);
      }
    }
    return result ?? false;
  }

  Future<bool> setDataCollectionConsentAccepted(WidgetRef ref, bool value) async {
    final result = await _sharedPreferences?.setBool(DataCollectionConsentKey, value);
    if (value && result == true) {
      try {
        await ref.read(agreementUpdateProvider).notifyAgreementAccepted(DataCollectionConsentKey);
      } catch (e) {
        _logger.error('Error updating data collection consent on server', e);
      }
    }
    return result ?? false;
  }

  // Debug method to reset all agreements
  Future<void> debugResetAllAgreements(WidgetRef ref) async {
    try {
      await _sharedPreferences?.setBool(PrivacyPolicyKey, false);
      await _sharedPreferences?.setBool(TermsOfServiceKey, false);
      await _sharedPreferences?.setBool(EndUserLicenseKey, false);
      await _sharedPreferences?.setBool(DataCollectionConsentKey, false);
      await ref.read(agreementUpdateProvider).notifyAllAgreementsReset();
      _logger.debug('All agreements have been reset');
    } catch (e) {
      _logger.error('Error resetting agreements', e);
    }
  }

  // Update the debug print method
  Future<void> debugPrintAgreementStates(WidgetRef ref) async {
    _logger.debug('''Agreement States:
      Privacy Policy Accepted (Local): ${_sharedPreferences?.getBool(PrivacyPolicyKey)}
      Terms of Service Accepted (Local): ${_sharedPreferences?.getBool(TermsOfServiceKey)}
      End User License Accepted (Local): ${_sharedPreferences?.getBool(EndUserLicenseKey)}
      Data Collection Consent Accepted (Local): ${_sharedPreferences?.getBool(DataCollectionConsentKey)}
      
      Privacy Policy Accepted (Server): ${await hasPrivacyPolicyAccepted(ref)}
      Terms of Service Accepted (Server): ${await hasTermsOfServiceAccepted(ref)}
      End User License Accepted (Server): ${await hasEndUserLicenseAccepted(ref)}
      Data Collection Consent Accepted (Server): ${await hasDataCollectionConsentAccepted(ref)}
    ''');
  }

  //============================================ PROFILE METHODS ==============================================//

  Future<String> getUserPictureURL(WidgetRef ref) async {
    try {
      final serverUserService = ref.read(serverUserServiceProvider);
      final serverStatus = await serverUserService.getUserProfileURL();
      return serverStatus;
    } catch (e , stacktrace) {
      _logger.error("Error loading UserPictureURL ! E:$e | ST:$stacktrace");
      return "https://i.sstatic.net/l60Hf.png";
    }
  }

  Future<bool> getChangeProfilePictureDisplayStatus(WidgetRef ref) async {
    try{
      final serverUserService = ref.read(serverUserServiceProvider);
      final serverStatus = await serverUserService.getChangeProfilePictureDisplayStatus();
      return serverStatus;
    }
    catch (e , stacktrace){
      _logger.error("Error loading UserPictureURL ! E:$e | ST:$stacktrace");
      return false;
    }
  }
}