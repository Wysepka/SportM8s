import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/calendar/container/CalendarStaticValues.dart';
import 'package:sportm8s/calendar/widgets/calendar_events_grid.dart';
import 'package:sportm8s/calendar/widgets/calendar_events_tile.dart';
import 'package:sportm8s/map/engine/sport_event_repository.dart';

class CalendarEventsBrowser extends StatefulWidget{
  final MainSportEventRepository mainSportEventRepository;
  final Function(CalendarEventsTile) calendarEventsTileClicked;

  const CalendarEventsBrowser(this.mainSportEventRepository,this.calendarEventsTileClicked, {super.key});

  @override
  State<StatefulWidget> createState() => _CalendarEventsBrowser();
}

class _CalendarEventsBrowser extends State<CalendarEventsBrowser>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 6,),
        Expanded(
            child: CalendarEventsGrid(widget.mainSportEventRepository ,widget.calendarEventsTileClicked)
        ),
      ],
    );
  }

  void getDaySelectionString(){

  }

}