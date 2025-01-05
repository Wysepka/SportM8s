
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storageServiceInitializerProvider = FutureProvider<StorageService>((ref) async {
  return await StorageService.getInstance();
});

class StorageService
{
  static const String PrivacyPolicyKey = "PrivacyPolicyAccepted";

  static StorageService? _storageService;
  static SharedPreferences? _sharedPreferences;

  static Future<StorageService> getInstance() async{
    _storageService ??= StorageService();
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _storageService!;
  }

  bool get hasPrivacyPolicyAccepted => _sharedPreferences?.getBool(PrivacyPolicyKey) ?? false;
}