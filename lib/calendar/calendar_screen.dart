import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/calendar/container/CalendarDateRange.dart';
import 'package:sportm8s/calendar/widgets/calendar_day_tile.dart';
import 'package:sportm8s/calendar/widgets/calendar_events_browser.dart';
import 'package:sportm8s/calendar/widgets/calendar_events_sorter.dart';
import 'package:sportm8s/calendar/widgets/calendar_events_tile.dart';
import 'package:sportm8s/calendar/widgets/calendar_top_bar.dart';
import 'package:sportm8s/calendar/widgets/calendar_week_bar.dart';
import 'package:sportm8s/map/engine/sport_event_repository.dart';

class CalendarScreen extends StatefulWidget{

  final MainSportEventRepository mainSportEventRepository;

  const CalendarScreen(this.mainSportEventRepository);

  @override
  State<StatefulWidget> createState() => _CalendarScreen();
}

class _CalendarScreen extends State<CalendarScreen>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CalendarTopBar(),
            SizedBox(height: 10,),
            CalendarWeekBar(onCalendarDateChanged , onCalendarDayTileClicked),
            SizedBox(height: 10,),
            CalendarEventsSorter(),
            SizedBox(height: 10,),
            Expanded(
                child: CalendarEventsBrowser(widget.mainSportEventRepository , onCalendarEventTileClicked)
            ),
          ],
        ),
      )
    );
  }

  dynamic onCalendarDateChanged(CalendarDateRange calendarDateRange){

  }

  void onCalendarDayTileClicked(CalendarDayTile calendarDayTile){

  }

  void onCalendarEventTileClicked(CalendarEventsTile eventsTile){

  }

}