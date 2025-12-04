
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapCreateEventDatePicker extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MapCreateEventDatePicker();
}

class _MapCreateEventDatePicker extends State<MapCreateEventDatePicker>{

  late DateTime selectedEventTime;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //Future<DateTime?> dateTime;
    final dateTime = showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
  }

}