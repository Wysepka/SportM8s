import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapEventPanelContainer extends StatelessWidget{
  final Widget child;

  MapEventPanelContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    var colorSheme = Theme.of(context).colorScheme;
    return Container(
        margin: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10
        ),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: colorSheme.outline,
            /*
          border: Border.all(
            color: Colors.grey,
            width: 8,
          ),
           */
          boxShadow:[
            BoxShadow(
              color: colorSheme.shadow.withOpacity(0.25), // shadow color
              blurRadius: 18,                         // softens the shadow
              spreadRadius: 1,                       // extends the shadow
              offset: Offset(0, 8),                  // moves shadow right & down
            ),
          ]
        ),

        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Container(
            decoration: BoxDecoration(
              color: colorSheme.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: colorSheme.outlineVariant,
                width: 1
              )
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: child,
          ),
        ),
      );
    }
}