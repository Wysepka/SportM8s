import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension MapEventWidgetTitleStyle on TextStyle {
  TextStyle mapEventWidgetTitle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return copyWith(
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    );
  }
}

extension MapEventBottomButtonStyle on TextStyle{
  TextStyle mapEventBottomButton(BuildContext context){
    final colorScheme = Theme.of(context).colorScheme;

    return copyWith(
      fontWeight: FontWeight.w900,
      color: colorScheme.onSurface,
      fontSize: 34,
    );
  }
}