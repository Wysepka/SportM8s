import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportm8s/bloc/calendar_sorter/calendar_query_container_bloc.dart';
import 'package:sportm8s/calendar/container/calendar_date_range.dart';
import 'package:sportm8s/calendar/widgets/calendar_day_tile.dart';
import 'package:sportm8s/calendar/widgets/calendar_events_browser.dart';
import 'package:sportm8s/calendar/widgets/calendar_events_sorter.dart';
import 'package:sportm8s/calendar/widgets/calendar_events_tile.dart';
import 'package:sportm8s/calendar/widgets/calendar_top_bar.dart';
import 'package:sportm8s/calendar/widgets/calendar_week_bar.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/map/engine/sport_event_repository.dart';

class CalendarScreen extends StatefulWidget{

  final MainSportEventRepository mainSportEventRepository;

  const CalendarScreen(this.mainSportEventRepository, {super.key});

  @override
  State<StatefulWidget> createState() => _CalendarScreen();
}

class _CalendarScreen extends State<CalendarScreen>{

  SportEventType sportEventTypeSelected = SportEventType.Invalid;
  EventDistanceQueryType eventDistanceSortType = EventDistanceQueryType.All;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalendarQueryContainerBloc>(
      create: (BuildContext context) {
        return CalendarQueryContainerBloc();
      },
      child: Scaffold(
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
                  child: CalendarEventsBrowser(widget.mainSportEventRepository , onCalendarEventTileClicked , sportEventTypeSelected , eventDistanceSortType)
              ),
            ],
          ),
        )
      ),
    );
  }

  dynamic onCalendarDateChanged(CalendarDateRange calendarDateRange){

  }

  void onCalendarDayTileClicked(CalendarDayTile calendarDayTile){

  }

  void onCalendarEventTileClicked(CalendarEventsTile eventsTile){

  }

  void onSorterDistanceChanged(EventDistanceQueryType eventDistanceSortType){
    if(context.mounted){
      setState(() {
        this.eventDistanceSortType = eventDistanceSortType;
      });
    }
  }

  void onSorterSportEventTypeChanged(SportEventType sportEventType){
    if(context.mounted){
      setState(() {
        sportEventTypeSelected = sportEventType;
      });
    }
  }

}