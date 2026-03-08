import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/gen/assets.gen.dart';
import 'package:sportm8s/services/server_service.dart';
import '../logger/logger_config.dart';

class AuthResult {
  final User? user;
  final String? error;
  final bool succesfull;
  
  AuthResult({this.user, this.error ,required this.succesfull});
  
  AuthResult.error(String errorMessage) 
      : error = errorMessage,
        user = null,
        succesfull = false;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final LoggerService loggerService = LoggerService();


  Future<AuthResult> connectToBackendServer(AuthResult previousResult , BuildContext context , ServerService serverService ,APIAuthConnectionType connectionType) async {
    try {

      if (previousResult.user != null) {
        loggerService.info('User successfully signed in to FirebaseAuth');
        // Try to connect to server after successful Google sign-in
        final connected = await serverService.connectToServer(connectionType);
        if (!context.mounted) {
          return AuthResult(succesfull: false);
        }

        if (!connected) {
          loggerService.error('Failed to connect to server');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to connect to server (Error ID: SERVER_CONNECTION_FAILED). Please try again later."),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          return AuthResult(succesfull: false , error: "Failed to connect to backend server !");
        }
        this.log.i('Successfully connected to server');

        return AuthResult(succesfull: true);
        //Navigator.pushReplacementNamed(context, "/aggreements");
      } else if (previousResult != null) {
        this.log.e('Google sign-in error: ${previousResult.error}');
        // Handle specific authentication errors
        String errorMessage = switch (previousResult.error) {
          'user-disabled' => 'This account has been disabled',
          'user-not-found' => 'No account found with this email',
          'invalid-credential' => 'Invalid credentials provided',
          'operation-not-allowed' => 'Google sign-in is not enabled',
          'network-request-failed' => 'Network connection failed',
          'popup-closed-by-user' => 'Sign-in cancelled by user',
          _ => previousResult.error ?? 'An unknown error occurred'
        };
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to connect to server Error:${errorMessage}."),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        return AuthResult(succesfull: false , error: errorMessage);
      }
    } catch (e) {
      loggerService.error('Unexpected error during login Error:${e.toString()}');
      if (!context.mounted) return AuthResult(succesfull: false ,error: e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not connect to backend server."),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return AuthResult(succesfull: false , error: "Could not connect to backend server");
    }

    return AuthResult(succesfull: false);
  }

  // Sign in with email and password
  Future<AuthResult> signInWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(userCredential.user != null) {
        loggerService.info('User signed in successfully with email');
        return AuthResult(user: userCredential.user , succesfull: true);
      }
      else{
        loggerService.info("Could not sign in with email: ${email} method");
        return AuthResult(succesfull: false);
      }
    } on FirebaseAuthException catch (e) {
      loggerService.error('Firebase Auth Exception during email sign-in Error:${e.toString()}');
      return AuthResult(error: getSignInErrorMessage(e.code) , succesfull: false);
    } catch (e) {
      loggerService.error('Unexpected error during email sign-in Error:${e.toString()}');
      return AuthResult(error: 'An error occurred. Please try again.' , succesfull: false);
    }
  }

  // Sign up with email and password
  Future<AuthResult> signUpWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final acs = ActionCodeSettings(
        url: 'https://auth.sportm8s.app/auth/verified', // where user ends up after success
        handleCodeInApp: false,                   // web first
      );

      final emailVerResult = await userCredential.user!.sendEmailVerification(acs);
      loggerService.info("Email veryfication email sent succesfully");

      if(userCredential.user != null) {
        loggerService.info('New user created successfully with email');
        return AuthResult(user: userCredential.user , succesfull: true);
      }
      else{
        loggerService.info("Could not create a new account with email:${email}");
        return AuthResult(succesfull: false);
      }
    } on FirebaseAuthException catch (e) {
      loggerService.error('Firebase Auth Exception during sign-up Error:${e.toString()}');
      return AuthResult(error: getSignUpErrorMessage(e.code) , succesfull: false);
    } catch (e) {
      loggerService.error('Unexpected error during sign-up Error:${e.toString()}');
      return AuthResult(error: 'An error occurred. Please try again.' , succesfull:  false);
    }
  }

  // Sign in with Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        loggerService.warning('Google sign-in was cancelled by user');
        return AuthResult.error('Sign in was cancelled');
      }

      loggerService.info('Google sign-in successful, getting auth details');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      loggerService.info('User successfully signed in with Google');
      return AuthResult(user: userCredential.user , succesfull: true);
      
    } on PlatformException catch (e) {
      loggerService.error('Platform Exception during Google sign-in Error:${e.toString()}');
      return AuthResult.error(_getPlatformErrorMessage(e.code));
    } catch (e) {
      loggerService.error('Unexpected error during Google sign-in Error:${e.toString()}');
      return AuthResult.error('An unexpected error occurred');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Sign out from Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();  // Revokes access
        await _googleSignIn.signOut();
      }

      if(kIsWeb) {
        // Clear any web storage/cache if running on web
        await _auth.setPersistence(Persistence.NONE);
      }

      loggerService.info('User signed out successfully');
    } catch (e) {
      loggerService.error('Error during sign-out Error:${e.toString()}');
      throw Exception('Failed to sign out: $e');
    }
  }

  Future<bool> hasUserVerifiedEmail() async{
    try{
      final user = _auth.currentUser;
      if (user == null) return false;

      await user.reload();                // fetch latest user profile from Firebase
      final refreshedUser = _auth.currentUser; // get updated instance

      return refreshedUser?.emailVerified ?? false;
    }
    catch(e){
      loggerService.error('Error during email-verification Error:${e.toString()}');
      throw Exception('Failed to check email verification: $e');
    }
  }


  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'Email is already in use.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  String _getPlatformErrorMessage(String code) {
    switch (code) {
      case 'sign_in_canceled':
      case 'canceled':
        return 'Sign in was cancelled';
      case 'network_error':
        return 'Network error occurred';
      case 'sign_in_failed':
      case 'failed':
        return 'Sign in failed';
      case 'api_not_available':
        return 'Google Play Services not available';
      case 'developer_error':
        return 'Configuration error - check your Firebase setup';
      case 'exception':
        return 'Authentication failed - please try again';
      default:
        print('Unhandled platform error code: $code'); // For debugging
        return 'An error occurred during sign in ($code)';
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  String getSignInErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'user-token-expired':
        return 'Your session has expired. Please sign in again.';
      case 'INVALID_LOGIN_CREDENTIALS':
      case 'invalid-credential':
        return 'Invalid login credentials. Please check your email and password.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled. Please contact support.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  String getSignUpErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'weak-password':
        return 'The password is not strong enough.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'user-token-expired':
        return 'Your session has expired. Please try again.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

// Providers
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
}); 