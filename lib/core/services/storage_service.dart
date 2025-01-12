import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storageServiceInitializerProvider = FutureProvider<StorageService>((ref) async {
  return await StorageService.getInstance();
});

class StorageService
{
  static const String PrivacyPolicyKey = "PrivacyPolicyAccepted";
  static const String TermsOfServiceKey = "TermsOfServiceAccepted";
  static const String EndUserLicenseKey = "EndUserLicenseAccepted";
  static const String DataCollectionConsentKey = "DataCollectionConsentAccepted";

  static StorageService? _storageService;
  static SharedPreferences? _sharedPreferences;

  static Future<StorageService> getInstance() async{
    _storageService ??= StorageService();
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _storageService!;
  }

  bool get hasPrivacyPolicyAccepted => _sharedPreferences?.getBool(PrivacyPolicyKey) ?? false;
  bool get hasTermsOfServiceAccepted => _sharedPreferences?.getBool(TermsOfServiceKey) ?? false;
  bool get hasEndUserLicenseAccepted => _sharedPreferences?.getBool(EndUserLicenseKey) ?? false;
  bool get hasDataCollectionConsentAccepted => _sharedPreferences?.getBool(DataCollectionConsentKey) ?? false;

  Future<bool>? setPrivacyPolicyAccepted(bool value) => _sharedPreferences?.setBool(PrivacyPolicyKey, value);
  Future<bool>? setTermsOfServiceAccepted(bool value) => _sharedPreferences?.setBool(TermsOfServiceKey, value);
  Future<bool>? setEndUserLicenseAccepted(bool value) => _sharedPreferences?.setBool(EndUserLicenseKey, value);
  Future<bool>? setDataCollectionConsentAccepted(bool value) => _sharedPreferences?.setBool(DataCollectionConsentKey, value);

  // Debug method to reset all agreements
  Future<void> debugResetAllAgreements() async {
    await _sharedPreferences?.setBool(PrivacyPolicyKey, false);
    await _sharedPreferences?.setBool(TermsOfServiceKey, false);
    await _sharedPreferences?.setBool(EndUserLicenseKey, false);
    await _sharedPreferences?.setBool(DataCollectionConsentKey, false);
  }

  // Optional: Debug method to print current agreement states
  void debugPrintAgreementStates() {
    print('Privacy Policy Accepted: $hasPrivacyPolicyAccepted');
    print('Terms of Service Accepted: $hasTermsOfServiceAccepted');
    print('End User License Accepted: $hasEndUserLicenseAccepted');
    print('Data Collection Consent Accepted: $hasDataCollectionConsentAccepted');
  }
}