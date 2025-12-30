import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapEventTopPanel extends StatelessWidget{
  final Function() _onDismissCreateEventTap;
  final String panelName;

  MapEventTopPanel(this._onDismissCreateEventTap , this.panelName );

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          decoration: BoxDecoration(
              boxShadow:[ BoxShadow(
                color: Colors.white.withOpacity(0.5), // shadow color
                blurRadius: 4,                         // softens the shadow
                spreadRadius: 4,                       // extends the shadow
                offset: Offset(1, 2),                  // moves shadow right & down
              ),],
              borderRadius:BorderRadius.circular(24),
              border: Border.all(
                  color: Colors.grey,
                  width: 6
              )
          ),

          child: Align(
            //widthFactor: 0.1,
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              icon: Icon(Icons.keyboard_return),
              onPressed: _onDismissCreateEventTap,
              label: Text(
                '',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),),
              //TODO add localisation
            ),
          ),
        ),
        Text(
          panelName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

}