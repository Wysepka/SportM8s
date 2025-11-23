import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapIconCreateEvent extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MapIconCreateEvent();

}

class _MapIconCreateEvent extends State<MapIconCreateEvent>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      width: 100,
      height: 100,
      child: Icon(
        Icons.location_on,
        color: Colors.red,
      ),
    );
  }

}