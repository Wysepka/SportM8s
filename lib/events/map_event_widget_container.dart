import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapEventWidgetContainer extends StatelessWidget
{
  final Widget child;

  const MapEventWidgetContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(0.8) ,
            width: 1),
          boxShadow:[
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.18), // shadow color
              //blurRadius: 2,                         // softens the shadow
              blurRadius: 10,                         // softens the shadow
              offset: Offset(0, 6),                  // moves shadow right & down
              ),
          ],
      ),

      child: DefaultTextStyle.merge(
          style: TextStyle(
              color: colorScheme.onSurface),
          child: child
      ),
    );
  }

}