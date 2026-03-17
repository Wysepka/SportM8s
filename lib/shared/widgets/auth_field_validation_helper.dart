import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sportm8s/features/auth/presentation/screens/email_auth_screen.dart';

class AuthFieldValidationHelper{
  String? onEmailSubmitted(String? value , BuildContext context , AuthFormFieldValidationData validationData){

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
      validationData.isProperlyValidated = false;
      validationData.rejectionReason = rejectionReason;
      debugPrint(rejectionReason);
      return rejectionReason;
    }

    if (!emailRegex.hasMatch(email)) {
      String rejectionReason = l10n?.authError_wrongEmailFormat ?? "Invalid email format";
      validationData.isProperlyValidated = false;
      validationData.rejectionReason = rejectionReason;
      debugPrint(rejectionReason);
      return rejectionReason;
    }

    validationData.isProperlyValidated = true;

    debugPrint('Email is valid');
    return null;
  }

  String? onPasswordSumbitted(String? password , BuildContext context, AuthFormFieldValidationData validationData){
    final l10n = AppLocalizations.of(context);

    if(password == null){
      return l10n?.auth_typeYourPassword ?? "Type your password";
    }

    if (password.isEmpty) {
      String rejectionReason = l10n?.auth_passwordIsRequired ?? "Password is required";
      validationData.isProperlyValidated = false;
      validationData.rejectionReason = rejectionReason;
      debugPrint(rejectionReason);
      return rejectionReason;
    }

    if (password.length < 8) {
      String rejectionReason = l10n?.auth_passwordMinChars ?? "Password must be minimum of 8 chars";
      validationData.isProperlyValidated = false;
      validationData.rejectionReason = rejectionReason;
      debugPrint(rejectionReason);
      return rejectionReason;
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      String rejectionReason = l10n?.auth_passwordMinOneUppercaseChar ?? "Password must have one uppercase letter";
      validationData.isProperlyValidated = false;
      validationData.rejectionReason = rejectionReason;
      debugPrint(rejectionReason);
      return rejectionReason;
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      String rejectionReason = l10n?.auth_passwordMinOneNumber ?? "Password must have at least one number";
      validationData.isProperlyValidated = false;
      validationData.rejectionReason = rejectionReason;
      debugPrint(rejectionReason);
      return rejectionReason;
    }

    validationData.isProperlyValidated = true;

    debugPrint('Password is valid');
    return null;
  }

}