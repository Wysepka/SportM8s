import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../services/server_service.dart';
import '../../../../core/logger/logger_config.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);
    final serverService = ref.read(serverServiceProvider);
    final l10n = AppLocalizations.of(context);

    void showErrorSnackBar(BuildContext context, String message) {
      this.log.e('Login Error: $message');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/email-signin");
              },
              child: Text(l10n?.signInWithEmail ?? "Sign in with Email"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/email-signup");
              },
              child: Text(l10n?.signUpWithEmail ?? 'Sign Up with Email'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  final result = await authService.signInWithGoogle();
                  if (!context.mounted) return;

                  if (result.user != null) {
                    this.log.i('User successfully signed in with Google');
                    // Try to connect to server after successful Google sign-in
                    final connected = await serverService.connectToServer();
                    if (!context.mounted) return;

                    if (!connected) {
                      this.log.e('Failed to connect to server');
                      showErrorSnackBar(
                        context, 
                        'Failed to connect to server (Error ID: SERVER_CONNECTION_FAILED). Please try again later.'
                      );
                      return;
                    }
                    this.log.i('Successfully connected to server');
                    Navigator.pushReplacementNamed(context, "/aggreements");
                  } else if (result.error != null) {
                    this.log.e('Google sign-in error: ${result.error}');
                    // Handle specific authentication errors
                    String errorMessage = switch (result.error) {
                      'user-disabled' => 'This account has been disabled',
                      'user-not-found' => 'No account found with this email',
                      'invalid-credential' => 'Invalid credentials provided',
                      'operation-not-allowed' => 'Google sign-in is not enabled',
                      'network-request-failed' => 'Network connection failed',
                      'popup-closed-by-user' => 'Sign-in cancelled by user',
                      _ => result.error ?? 'An unknown error occurred'
                    };
                    showErrorSnackBar(context, errorMessage);
                  }
                } catch (e) {
                  this.log.e('Unexpected error during login', error: e);
                  if (!context.mounted) return;
                  showErrorSnackBar(
                    context, 
                    'An unexpected error occurred. Please try again.'
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