import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/features/auth/presentation/screens/aggreements_screen.dart';
import 'package:sportm8s/features/auth/presentation/screens/email_verified_screen.dart';
import 'package:sportm8s/features/auth/presentation/screens/email_verify_screen.dart';
import 'package:sportm8s/features/auth/presentation/screens/password_reset_success_screen.dart';
import 'package:sportm8s/graphics/sportm8s_themes.dart';
import 'package:sportm8s/map/map_root_screen.dart';
import 'package:sportm8s/profile/views/change_display_profile_screen.dart';
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'firebase_options.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/home_page.dart';
import 'core/services/auth_service.dart';
import 'features/auth/presentation/screens/email_auth_screen.dart';
import 'core/logger/logger_config.dart';
import 'map/engine/sport_event_repository.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

class MyApp extends ConsumerStatefulWidget{
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyApp();

}

class _MyApp extends ConsumerState<MyApp> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();

    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    final initialLink = await _appLinks.getInitialLink();
    if(initialLink != null){
      _handleUri(initialLink);
    }

    _sub = _appLinks.uriLinkStream.listen((uri) { _handleUri(uri);});
  }

  void _handleUri(Uri uri){
    if(uri.path == '/open-app'){
      final mode = uri.queryParameters['mode'];

      if (mode == 'resetPassword') {
        navigatorKey.currentState?.pushReplacementNamed('/password-reset');
      } else {
        navigatorKey.currentState?.pushReplacementNamed('/email-verified');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    _sub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MaterialApp(
      title: 'SportM8s',
      navigatorKey: navigatorKey,
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
        '/email-verify': (context) => const EmailVerifyScreen(),
        '/email-verified': (context) => const EmailVerifiedScreen(),
        '/password-reset': (context) => const PasswordResetSuccessScreen(),
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
