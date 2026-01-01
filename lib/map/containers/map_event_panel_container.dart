import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapEventPanelContainer extends StatelessWidget{
  final Widget child;

  MapEventPanelContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey,
            width: 8,
          ),
          color: Colors.white,
          boxShadow:[
            BoxShadow(
              color: Colors.grey, // shadow color
              blurRadius: 8,                         // softens the shadow
              spreadRadius: 1,                       // extends the shadow
              offset: Offset(2, 4),                  // moves shadow right & down
            ),
          ]
        ),
        child: child,
      );
    }
}