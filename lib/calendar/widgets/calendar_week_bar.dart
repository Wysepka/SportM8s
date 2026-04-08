import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportm8s/bloc/calendar_sorter/calendar_query_container_bloc.dart';
import 'package:sportm8s/bloc/calendar_sorter/calendar_query_container_event.dart';
import 'package:sportm8s/calendar/container/calendar_date_range.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/utility/time_utility.dart';
import 'package:sportm8s/events/map_event_widget_container.dart';

import '../../graphics/sportm8s_themes.dart';
import 'calendar_day_tile.dart';

class CalendarWeekBar extends StatefulWidget{

  const CalendarWeekBar({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarWeekBar();
}

class _CalendarWeekBar extends State<CalendarWeekBar>{
  CalendarBarDateContainer barDateContainer = CalendarBarDateContainer();

  @override
  Widget build(BuildContext context) {
    return MapEventWidgetContainer(
      marginVertical: 5,
      marginHorizontal: 5,
      paddingHorizontal: 3,
      paddingVertical: 5,
      child: Row(
        children: [
          ...getWeekTiles(barDateContainer.selectedDateTime).map((w) => Expanded(child: w)),
          CalendarDayTile(
              weekDay: CalendarWeekDay.Invalid,
              monthDayID: 0,
              hasEventsThisDay: true,
              dateTimeSelectedFunction: onCalendarTileClicked,
              isSelected: barDateContainer.weekButtonType == CalendarWeekButtonType.All,
              dateTime: DateTime.now(),
              weekButtonType: CalendarWeekButtonType.All,
          ),
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
      DateTime dayTileDateTime = calendarDateRange.weekDateTime[i];
      CalendarWeekDay weekDay = TimeUtility.intToWeekDay(i);
      int monthDayID = calendarDateRange.dateDayRange[i];
      bool isSelected = TimeUtility.isSameDate(barDateContainer.selectedDateTime ,dayTileDateTime) && barDateContainer.weekButtonType == CalendarWeekButtonType.DateTime;
      weekDays.add(CalendarDayTile(
        weekDay: weekDay,
        monthDayID: monthDayID ,
        hasEventsThisDay: true ,
        dateTimeSelectedFunction:  onCalendarTileClicked,
        isSelected: isSelected ,
        dateTime: dayTileDateTime ,
        weekButtonType: CalendarWeekButtonType.DateTime,
      ));
    }

    return weekDays;
  }

  void onCalendarButtonClicked() async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days: 30)),
        lastDate: DateTime.now().add(Duration(days: 365)),
        builder: (context , child){
          return SportM8sTheme.datePickerTheme(child, context);
        }
    );


    if(date != null && context.mounted) {
      setState(() {
        barDateContainer.selectedDateTime = date;
        barDateContainer.calendarDateRange = TimeUtility.getCalendarDateRange(date);
        barDateContainer.weekButtonType = CalendarWeekButtonType.DateTime;
        context.read<CalendarQueryContainerBloc>().add(CalendarEventDateRangeChanged(barDateContainer));
      });
    }
  }

  void onCalendarTileClicked(CalendarDayTile dayTile){
    if(context.mounted) {
      setState(() {
        barDateContainer.selectedDateTime = dayTile.dateTime;
        barDateContainer.calendarDayTile = dayTile;
        barDateContainer.weekButtonType = dayTile.weekButtonType;
        context.read<CalendarQueryContainerBloc>().add(CalendarEventDateRangeChanged(barDateContainer));
      });
    }
  }

}

class CalendarBarDateContainer{
  DateTime selectedDateTime = DateTime.now();
  CalendarDateRange calendarDateRange = TimeUtility.getCalendarDateRange(DateTime.now());
  CalendarDayTile? calendarDayTile;
  CalendarWeekButtonType weekButtonType = CalendarWeekButtonType.All;
}