import 'package:flutter/material.dart';
import '../../core/platform/platform_service.dart';

abstract class PlatformAwareWidget extends StatelessWidget {
  final PlatformService platformService;

  const PlatformAwareWidget({
    Key? key,
    required this.platformService,
  }) : super(key: key);

  Widget buildAndroidWidget(BuildContext context);
  Widget buildIOSWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (platformService.isIOS) {
      return buildIOSWidget(context);
    }
    return buildAndroidWidget(context);
  }
} 