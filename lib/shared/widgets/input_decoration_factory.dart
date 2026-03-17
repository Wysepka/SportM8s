import 'package:flutter/material.dart';
import '../../graphics/sportm8s_themes.dart';

class InputDecorationFactory{

  static InputDecoration sportM8sAuthFieldDecoration({
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
}