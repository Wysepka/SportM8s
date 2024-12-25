import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../shared/widgets/platform_aware_widget.dart';
import '../../../../core/platform/platform_service.dart';

class LoginButton extends PlatformAwareWidget {
  final VoidCallback onPressed;
  final String text;

  const LoginButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required PlatformService platformService,
  }) : super(key: key, platformService: platformService);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        // Android-specific styling
      ),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Text(text),
      // iOS-specific styling
    );
  }
} 