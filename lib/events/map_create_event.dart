

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapCreateEvent extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DraggableScrollableSheet(
        builder: (context, controller) {
          return Column(
            children: [
              Text("Sport Type" , style: TextStyle(fontSize: 20)),
              Text("Sport Difficulty", style: TextStyle(fontSize: 20)),
              Text("Sport Difficulty", style: TextStyle(fontSize: 20)),
              Text("Sport Difficulty", style: TextStyle(fontSize: 20)),
              Text("Sport Difficulty", style: TextStyle(fontSize: 20)),
            ],
          );
        }
    );
  }

}