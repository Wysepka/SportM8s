import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/services/auth_service.dart';
import 'email_sign_in_screen.dart';
import 'email_sign_up_screen.dart';
import 'home_page.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context , "/email-signin");
              },
              child: Text(l10n?.signInWithEmail ?? "Sign in with Email"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context , "/email-signup");
              },
              child: Text(l10n?.signUpWithEmail ?? 'Sign Up with Email'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await authService.signInWithGoogle();
                if (result.user != null && context.mounted) {
                  Navigator.pushReplacementNamed(context, "/aggreements"
                  );
                } else if (result.error != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result.error!)),
                  );
                }
              },
              icon: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_"G"_logo.svg/1200px-Google_"G"_logo.svg.png',
                height: 24,
              ),
              label: Text(l10n?.continueWithGoogle ?? 'Continue with Google'),
            ),
          ],
        ),
      ),
    );
  }
} 