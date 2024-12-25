import 'dart:io';

abstract class PlatformService {
  bool get isIOS;
  bool get isAndroid;
  Future<void> platformSpecificOperation();
}

class PlatformServiceImpl implements PlatformService {
  @override
  bool get isIOS => Platform.isIOS;

  @override
  bool get isAndroid => Platform.isAndroid;

  @override
  Future<void> platformSpecificOperation() async {
    if (isIOS) {
      // iOS specific implementation
    } else if (isAndroid) {
      // Android specific implementation
    }
  }
} 