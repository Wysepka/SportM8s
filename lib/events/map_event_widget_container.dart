import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapEventWidgetContainer extends StatelessWidget
{
  final Widget child;
  final double? marginHorizontal;
  final double? marginVertical;

  const MapEventWidgetContainer({required this.child , this.marginHorizontal , this.marginVertical});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
        margin: EdgeInsets.symmetric(
          horizontal: marginHorizontal ?? 20,
          vertical: marginVertical ?? 10
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