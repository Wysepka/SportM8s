import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/calendar/container/CalendarDateRange.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/utility/time_utility.dart';
import 'package:sportm8s/events/map_event_widget_container.dart';

import '../../graphics/sportm8s_themes.dart';
import 'calendar_day_tile.dart';

class CalendarWeekBar extends StatefulWidget{

  final Function(CalendarDateRange) dateTimeSelectedFunction;
  final Function(CalendarDayTile) onCalendarTileClicked;

  const CalendarWeekBar(this.dateTimeSelectedFunction,this.onCalendarTileClicked, {super.key});

  @override
  State<StatefulWidget> createState() => _CalendarWeekBar();
}

class _CalendarWeekBar extends State<CalendarWeekBar>{
  DateTime selectedDateTime = DateTime.now();
  CalendarDateRange calendarDateRange = TimeUtility.getCalendarDateRange(DateTime.now());
  CalendarDayTile? calendarDayTile;

  @override
  Widget build(BuildContext context) {
    return MapEventWidgetContainer(
      marginVertical: 5,
      marginHorizontal: 5,
      paddingHorizontal: 3,
      paddingVertical: 5,
      child: Row(
        children: [
          ...getWeekTiles(selectedDateTime).map((w) => Expanded(child: w)),
          IconButton(
              onPressed: onCalendarButtonClicked,
              icon: Icon(Icons.calendar_today)
          )
        ]
      ),
    );
  }

  List<CalendarDayTile> getWeekTiles(DateTime selectedDate){
    CalendarDateRange calendarDateRange = TimeUtility.getCalendarDateRange(selectedDate);

    List<CalendarDayTile> weekDays = [];
    for(int i=0; i < calendarDateRange.dateDayRange.length; i++){
      CalendarWeekDay weekDay = TimeUtility.intToWeekDay(i);
      weekDays.add(CalendarDayTile(weekDay: weekDay, monthDayID: calendarDateRange.dateDayRange[i] , hasEventsThisDay: true ,dateTimeSelectedFunction:  onCalendarTileClicked,));
    }

    return weekDays;
  }

  void onCalendarButtonClicked() async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),
        builder: (context , child){
          return SportM8sTheme.datePickerTheme(child, context);
        }
    );


    if(date != null) {
      setState(() {
        selectedDateTime = date;
        widget.dateTimeSelectedFunction(calendarDateRange);
      });
    }
  }

  void onCalendarTileClicked(CalendarDayTile dayTile){
    if(dayTile != null){
      widget.onCalendarTileClicked(dayTile);
    }
  }
}