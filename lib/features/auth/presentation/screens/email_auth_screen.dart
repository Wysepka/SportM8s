import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/logger/logger_config.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../graphics/sportm8s_themes.dart';
import '../../../../services/server_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailAuthScreen extends ConsumerStatefulWidget {
  final bool isSignIn;

  const EmailAuthScreen({super.key, required this.isSignIn});

  @override
  ConsumerState<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends ConsumerState<EmailAuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoggerService loggerService = LoggerService();

  AuthFormFieldValidationData emailValidationData = AuthFormFieldValidationData();
  AuthFormFieldValidationData passwordValidationData = AuthFormFieldValidationData();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final serverService = ref.read(serverServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSignIn ? l10n?.signInWithEmail ?? 'Sign In with Email' : l10n?.signUpWithEmail ?? 'Sign Up with Email'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: _sportM8sAuthFieldDecoration(
                    labelText: l10n?.email ?? "Email",
                    hintText: "you@gmail.com",
                    errorText: emailValidationData.rejectionReason,
                    iconData: Icons.email_outlined
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: _onEmailSubmitted,
                  textInputAction: TextInputAction.next,
                  validator: _onEmailSubmitted,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: _sportM8sAuthFieldDecoration(
                      labelText: l10n?.password ?? "Password",
                      hintText: l10n?.loginPasswordCharsReq ?? 'Min 8 chars, A-Z, 0-9',
                      errorText: passwordValidationData.rejectionReason,
                      iconData: Icons.lock_outline,
                  ),
                  obscureText: true,
                  onFieldSubmitted: _onPasswordSumbitted,
                  textInputAction: TextInputAction.done,
                  validator: _onPasswordSumbitted,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        var resultFirebase = AuthResult(succesfull: false);
                        if (widget.isSignIn) {
                          resultFirebase = await ref.read(authServiceProvider).signInWithEmailPassword(
                            _emailController.text,
                            _passwordController.text,
                          );
                        } else {
                          resultFirebase = await ref.read(authServiceProvider).signUpWithEmailPassword(
                            _emailController.text,
                            _passwordController.text,
                          );
                        }

                        AuthResult resultBackendServer = AuthResult(succesfull: false);

                        if(context.mounted) {
                          resultBackendServer = await ref.read(
                              authServiceProvider).connectToBackendServer(
                              resultFirebase, context, serverService , widget.isSignIn ? APIAuthConnectionType.Signin : APIAuthConnectionType.Login);
                        }

                        if(resultBackendServer.succesfull && resultFirebase.succesfull && resultFirebase.user != null) {
                          if(!context.mounted){
                            return;
                          }
                          if (resultFirebase.user!.emailVerified) {
                            Navigator.pushReplacementNamed(
                                context, '/aggreements');
                          }
                          else{
                            Navigator.pushReplacementNamed(
                                context, '/email-verify');
                          }
                        }
                        else{
                          loggerService.error("Could not log in with email: ${_emailController.text} , Error:${resultFirebase.error?? "error not available"}");
                          if (mounted) {
                            if(resultFirebase.error != null){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(resultFirebase.error.toString()),
                              ));
                            }
                            else if(resultBackendServer.error != null){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(resultBackendServer.error.toString()),
                              ));
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(widget.isSignIn
                                    ? l10n?.errorLoginIn ?? "Could not sign in"
                                    : l10n?.errorSignUp ?? "Could not sign up")),
                              );
                            }
                          }
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      }
                    }
                  },
                  icon: Icon(Icons.check),
                  label: Text(widget.isSignIn ? l10n?.signIn ?? 'Sign In' : l10n?.signUp ?? 'Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _onEmailSubmitted(String? value){

    final l10n = AppLocalizations.of(context);

    if(value == null){
      return l10n?.authError_writeYourEmail ?? "Write your email";
    }

    final email = value.trim();

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (email.isEmpty) {
      String rejectionReason = l10n?.authError_emailIsRequired ?? "Email is required";
      emailValidationData.isProperlyValidated = false;
      emailValidationData.rejectionReason = rejectionReason;
      debugPrint(rejectionReason);
      return rejectionReason;
    }

    if (!emailRegex.hasMatch(email)) {
      String rejectionReason = l10n?.authError_wrongEmailFormat ?? "Invalid email format";
      emailValidationData.isProperlyValidated = false;
      emailValidationData.rejectionReason = rejectionReason;
      debugPrint(rejectionReason);
      return rejectionReason;
    }

    emailValidationData.isProperlyValidated = true;

    debugPrint('Email is valid');
    return null;
  }

  String? _onPasswordSumbitted(String? password){
    final l10n = AppLocalizations.of(context);

    if(password == null){
      return l10n?.auth_typeYourPassword ?? "Type your password";
    }

    if (password.isEmpty) {
      String rejectionReason = l10n?.auth_passwordIsRequired ?? "Password is required";
      passwordValidationData.isProperlyValidated = false;
      passwordValidationData.rejectionReason = rejectionReason;
      debugPrint(rejectionReason);
      return rejectionReason;
    }

    if (password.length < 8) {
      String rejectionReason = l10n?.auth_passwordMinChars ?? "Password must be minimum of 8 chars";
      passwordValidationData.isProperlyValidated = false;
      passwordValidationData.rejectionReason = rejectionReason;
      debugPrint(rejectionReason);
      return rejectionReason;
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      String rejectionReason = l10n?.auth_passwordMinOneUppercaseChar ?? "Password must have one uppercase letter";
      passwordValidationData.isProperlyValidated = false;
      passwordValidationData.rejectionReason = rejectionReason;
      debugPrint(rejectionReason);
      return rejectionReason;
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      String rejectionReason = l10n?.auth_passwordMinOneNumber ?? "Password must have at least one number";
      passwordValidationData.isProperlyValidated = false;
      passwordValidationData.rejectionReason = rejectionReason;
      debugPrint(rejectionReason);
      return rejectionReason;
    }

    passwordValidationData.isProperlyValidated = true;

    debugPrint('Password is valid');
    return null;
  }

  InputDecoration _sportM8sAuthFieldDecoration({
    required String labelText,
    required String hintText,
    required String errorText,
    required IconData iconData,
  }){
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      icon: Icon(iconData),
      filled: true,
      fillColor: SportM8sColors.surface,

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: SportM8sColors.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: SportM8sColors.error)
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: SportM8sColors.accent),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: SportM8sColors.divider),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: SportM8sColors.divider),
      )
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class AuthFormFieldValidationData{
  bool isProperlyValidated = false;
  String rejectionReason = "";
}