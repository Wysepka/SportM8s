import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/map/models/map_sport_event_marker.dart';

class CalendarEventsTile extends StatefulWidget{
  final Function(CalendarEventsTile) calendarEventsTileClicked;
  final MapSportEventData mapSportEventData;

  const CalendarEventsTile(this.calendarEventsTileClicked,this.mapSportEventData, {super.key});

  @override
  State<StatefulWidget> createState() => _CalendarEventsTile();

}

class _CalendarEventsTile extends State<CalendarEventsTile>{
  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: onTileTapped,
      ),
    );
  }

  void onTileTapped(){
    widget.calendarEventsTileClicked(widget);
  }
}