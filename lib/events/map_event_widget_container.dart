import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapEventWidgetContainer extends StatelessWidget
{
  final Widget child;

  const MapEventWidgetContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey ,
          width: 2),
        boxShadow:[
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // shadow color
            blurRadius: 2,                         // softens the shadow
            spreadRadius: 0,                       // extends the shadow
            offset: Offset(1, 2),                  // moves shadow right & down
            ),
        ],
      ),
      child: child,
    );
  }

}