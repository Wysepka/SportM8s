import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sportm8s/core/services/auth_service.dart';
import 'package:sportm8s/events/map_event_widget_container.dart';
import 'package:sportm8s/shared/widgets/auth_field_validation_helper.dart';

import '../../../../core/enums/enums_container.dart';
import '../../../../core/logger/logger_service.dart';
import '../../../../shared/widgets/input_decoration_factory.dart';
import 'email_auth_screen.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget{
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResetPasswordScreen();

}

class _ResetPasswordScreen extends ConsumerState<ResetPasswordScreen>{

  TextEditingController _emailController = TextEditingController();
  AuthFormFieldValidationData emailValidationData = AuthFormFieldValidationData();
  AuthFieldValidationHelper authFieldValidation = AuthFieldValidationHelper();

  LoggerService loggerService = LoggerService();
  ResetPasswordEmailState resetEmailStatus = ResetPasswordEmailState.Invalid;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authService = ref.read(authServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.auth_ResetPasswordScreenTitle ?? "Reset password"),
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(resetEmailStatus == ResetPasswordEmailState.Invalid)...{
                Text(l10n?.auth_ResetPasswordEmail ?? "Reset Password" , style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 10,),
                MapEventWidgetContainer(
                    child: Column(
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
                            onFieldSubmitted: validateEmailField,
                            textInputAction: TextInputAction.next,
                            validator: validateEmailField_String,
                          ),
                          SizedBox(height: 5,),
                          ElevatedButton.icon(
                            onPressed: () => sendResetPasswordEmail(authService , _emailController.text),
                            label: Text(
                                l10n?.auth_ResetPasswordButton ?? "Send" ,
                                style: Theme.of(context).textTheme.labelLarge),
                            icon: Icon(Icons.lock_reset , color: Colors.white,),
                          )
                      ],
                    )
                ),
              }
              else if(resetEmailStatus == ResetPasswordEmailState.InSendProcess)...{
                Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  )
                ),
              }
              else...{
                Center(
                  child: Text(resetEmailStatus == ResetPasswordEmailState.SendSuccesfull ?
                      l10n?.auth_ResetPasswordEmailSuccesfull.replaceFirst("`email`", _emailController.text)
                      ?? "Reset password successful"
                      :
                      l10n?.auth_ResetPasswordEmailWrong.replaceFirst("`email`", _emailController.text ) ?? "Could not deliver email")
                ),
                SizedBox(height: 5,),
                ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    label: Text(l10n?.auth_ResetPasswordScreenReturnButton ?? "Return"),
                    icon: Icon(Icons.keyboard_return , color: Colors.black,),
                ),
              }
            ],
        ),
      ),
    );
  }

  void validateEmailField(String? fieldValue){
    authFieldValidation.onEmailSubmitted(fieldValue, context, emailValidationData);
  }

  String? validateEmailField_String(String? fieldValue){
    return authFieldValidation.onEmailSubmitted(fieldValue, context, emailValidationData);
  }

  Future<bool> sendResetPasswordEmail(AuthService authService , String email) async {
    try{
      authFieldValidation.onEmailSubmitted(_emailController.text, context, emailValidationData);
      if(!emailValidationData.isProperlyValidated){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email format is wrong: ${emailValidationData.rejectionReason}" )));
        return false;
      }
      setState(() {
        resetEmailStatus = ResetPasswordEmailState.InSendProcess;
      });
      final sendResult = await authService.sendPasswordResetEmail(email);
      setState(() {
        resetEmailStatus = sendResult ? ResetPasswordEmailState.SendSuccesfull : ResetPasswordEmailState.SendError;
      });
      return sendResult;
    }
    catch(e){
      loggerService.error("Could not send email reset email , $e");
      return false;
    }
  }

}