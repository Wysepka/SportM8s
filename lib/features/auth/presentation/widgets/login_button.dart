import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/auth_service.dart';

class LoginButton extends ConsumerWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onError;

  const LoginButton({
    Key? key,
    this.onSuccess,
    this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final result = await ref.read(authServiceProvider).signInWithGoogle();
          if (result.error == null) {
            onSuccess?.call();
          } else {
            onError?.call();
          }
        } catch (e) {
          onError?.call();
        }
      },
      child: const Text('Sign in with Google'),
    );
  }
} 