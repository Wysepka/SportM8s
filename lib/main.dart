import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/features/auth/presentation/screens/aggreements_screen.dart';
import 'package:sportm8s/graphics/sportm8s_themes.dart';
import 'package:sportm8s/map/map_root_screen.dart';
import 'package:sportm8s/profile/views/change_display_profile_screen.dart';
import 'package:sportm8s/features/auth/presentation/screens/privacy_policy_screen.dart';
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'firebase_options.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/home_page.dart';
import 'core/services/auth_service.dart';
import 'features/auth/presentation/screens/email_auth_screen.dart';
import 'core/logger/logger_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize logger before running the app
  LoggerConfig.initialize(
    isDevelopment: const bool.fromEnvironment('dart.vm.product') == false,
  );
  
  // Add error logging using the new logger
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    LoggerConfig.logger.e('Flutter Error', error: details.exception, stackTrace: details.stack);
  };
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    LoggerConfig.logger.i('Firebase initialized successfully');
  } catch (e, stackTrace) {
    LoggerConfig.logger.e('Firebase initialization error', error: e, stackTrace: stackTrace);
  }
  
  debugPrintRebuildDirtyWidgets = true;
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return MaterialApp(
      title: 'SportM8s',
      theme: SportM8sTheme.dark(),
      home: Consumer(
        builder: (context, ref, child) {
          final authState = ref.watch(authStateProvider);
          return authState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${error.toString()}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n?.event_Button_Back_Tooltip ?? 'Go Back'),
                    ),
                  ],
                ),
              ),
            ),
            data: (user) => const LoginScreen(),
          );
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
        '/email-signin': (context) => const EmailAuthScreen(isSignIn: true),
        '/email-signup': (context) => const EmailAuthScreen(isSignIn: false),
        '/aggreements': (context) => const AggreementsScreen(),
        '/change-profile-screen': (context) => const ChangeDisplayProfileScreen(),
        '/map-root-screen': (context) => const MapRootScreen(),
      },
      localizationsDelegates: const[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en"),
        Locale("pl"),
      ],
    );
  }
}
