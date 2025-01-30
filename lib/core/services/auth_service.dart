import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../logger/logger_config.dart';

class AuthResult {
  final User? user;
  final String? error;
  
  AuthResult({this.user, this.error});
  
  AuthResult.error(String errorMessage) 
      : error = errorMessage,
        user = null;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with email and password
  Future<AuthResult> signInWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      this.log.i('User signed in successfully with email');
      return AuthResult(user: userCredential.user);
    } on FirebaseAuthException catch (e) {
      this.log.e('Firebase Auth Exception during email sign-in', error: e);
      return AuthResult(error: getSignInErrorMessage(e.code));
    } catch (e) {
      this.log.e('Unexpected error during email sign-in', error: e);
      return AuthResult(error: 'An error occurred. Please try again.');
    }
  }

  // Sign up with email and password
  Future<AuthResult> signUpWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      this.log.i('New user created successfully with email');
      return AuthResult(user: userCredential.user);
    } on FirebaseAuthException catch (e) {
      this.log.e('Firebase Auth Exception during sign-up', error: e);
      return AuthResult(error: getSignUpErrorMessage(e.code));
    } catch (e) {
      this.log.e('Unexpected error during sign-up', error: e);
      return AuthResult(error: 'An error occurred. Please try again.');
    }
  }

  // Sign in with Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        this.log.w('Google sign-in was cancelled by user');
        return AuthResult.error('Sign in was cancelled');
      }

      this.log.d('Google sign-in successful, getting auth details');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      this.log.i('User successfully signed in with Google');
      return AuthResult(user: userCredential.user);
      
    } on PlatformException catch (e) {
      this.log.e('Platform Exception during Google sign-in', error: e);
      return AuthResult.error(_getPlatformErrorMessage(e.code));
    } catch (e) {
      this.log.e('Unexpected error during Google sign-in', error: e);
      return AuthResult.error('An unexpected error occurred');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      this.log.i('User signed out successfully');
    } catch (e) {
      this.log.e('Error during sign-out', error: e);
      throw Exception('Failed to sign out: $e');
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