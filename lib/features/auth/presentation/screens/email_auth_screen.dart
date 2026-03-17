import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/logger/logger_config.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:sportm8s/shared/widgets/auth_field_validation_helper.dart';
import 'package:sportm8s/shared/widgets/input_decoration_factory.dart';
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

  PasswordAPIValidationSession passwordAPIValidationSession = PasswordAPIValidationSession();

  AuthFieldValidationHelper validationHelper = AuthFieldValidationHelper();

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
                  decoration: InputDecorationFactory.sportM8sAuthFieldDecoration(
                    labelText: l10n?.email ?? "Email",
                    hintText: "you@gmail.com",
                    errorText: emailValidationData.rejectionReason,
                    iconData: Icons.email_outlined
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (String fieldValue) => validationHelper.onEmailSubmitted(fieldValue , context , emailValidationData),
                  textInputAction: TextInputAction.next,
                  validator: (String? fieldValue) => validationHelper.onEmailSubmitted(fieldValue , context , emailValidationData),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecorationFactory.sportM8sAuthFieldDecoration(
                      labelText: l10n?.password ?? "Password",
                      hintText: l10n?.loginPasswordCharsReq ?? 'Min 8 chars, A-Z, 0-9',
                      errorText: passwordValidationData.rejectionReason,
                      iconData: Icons.lock_outline,
                  ),
                  obscureText: true,
                  onFieldSubmitted: (String fieldValue) => validationHelper.onPasswordSumbitted(fieldValue , context , emailValidationData),
                  textInputAction: TextInputAction.done,
                  validator: (String? fieldValue) => validationHelper.onPasswordSumbitted(fieldValue , context , emailValidationData),
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

                        if(!resultBackendServer.succesfull && resultBackendServer.errorID != null){
                          if(resultBackendServer.errorID == "wrong-password"){

                          }
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
                            Navigator.pushNamed(
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
                if(widget.isSignIn)...[ //is logging page add reset password button
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(context ,
                        MaterialPageRoute(
                            builder: (_) => ResetPasswordScreen())
                    ),
                    label: Text(l10n?.auth_ResetPasswordEmail ?? "Reset Password"),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
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

class PasswordAPIValidationSession{
  bool hasProvidedIncorrectPassword = false;
  int incorrectPasswordProvidedCount = 0;
}