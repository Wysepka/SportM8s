import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/graphics/sportm8s_themes.dart';

class CalendarTextIconContainer extends StatelessWidget{

  final Color backgroundColor;
  final Icon icon;
  final String text;
  final TextStyle? textStyle;

  const CalendarTextIconContainer(this.backgroundColor, this.icon , this.text, this.textStyle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: SportM8sColors.surfaceTint,
      child: Row(
        children: [
          icon,
          Text(
              text ,
              style: textStyle ?? Theme.of(context).textTheme.bodyMedium)
        ],
      ),
    );
  }

}