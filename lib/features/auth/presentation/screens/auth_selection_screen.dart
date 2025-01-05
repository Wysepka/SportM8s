import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/services/auth_service.dart';

class AuthSelectionScreen extends ConsumerWidget {
  final bool isSignIn;

  const AuthSelectionScreen({super.key, required this.isSignIn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isSignIn ? l10n?.signIn ??  'Sign In' : l10n?.signUp ?? 'Sign Up'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  isSignIn ? '/email-signin' : '/email-signup',
                );
              },
              child: Text(l10n?.continueWithEmail ?? "Continue with Email"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(authServiceProvider).signInWithGoogle();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/aggreements');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              child: Text(l10n?.continueWithGoogle ?? "Continue with Google"),
            ),
          ],
        ),
      ),
    );
  }
} 