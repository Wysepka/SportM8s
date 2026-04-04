import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportm8s/bloc/calendar_sorter/calendar_query_container_bloc.dart';
import 'package:sportm8s/calendar/widgets/calendar_events_browser.dart';
import 'package:sportm8s/calendar/widgets/calendar_events_sorter.dart';
import 'package:sportm8s/calendar/widgets/calendar_events_tile.dart';
import 'package:sportm8s/calendar/widgets/calendar_top_bar.dart';
import 'package:sportm8s/calendar/widgets/calendar_week_bar.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/dto/api_result.dart';
import 'package:sportm8s/events/map_join_event.dart';
import 'package:sportm8s/map/engine/sport_event_engine.dart';
import 'package:sportm8s/map/engine/sport_event_repository.dart';
import 'package:sportm8s/map/models/map_event_data.dart';

class CalendarScreen extends StatefulWidget{

  final SportEventEngine sportEventEngine;

  const CalendarScreen(this.sportEventEngine, {super.key});

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
              CalendarWeekBar(),
              SizedBox(height: 10,),
              CalendarEventsSorter(),
              SizedBox(height: 10,),
              Expanded(
                  child: CalendarEventsBrowser(widget.sportEventEngine.eventRepository as MainSportEventRepository, onCalendarEventTileClicked , sportEventTypeSelected , eventDistanceSortType)
              ),
            ],
          ),
        )
      ),
    );
  }

  void onCalendarEventTileClicked(CalendarEventsTile eventsTile){
    Navigator.of(context).push(
      MaterialPageRoute(builder:
        (context) => Scaffold(
          appBar: AppBar(
              title: Text("Join Event")
          ),
          body: SafeArea(
            child: MapJoinEvent(
              eventsTile.mapSportEventData,
              _onApplyJoinEvent,
              () => {},
              widget.sportEventEngine.sportService,
              _onDeleteEvent,
              _onUserButtonRequestSend,
              widget.sportEventEngine.eventRepository as MainSportEventRepository,
              MapJoinEventScreenType.Calendar,
            ),
          ),
        )
    ));
  }

  void _onApplyJoinEvent(MapEventData mapEventData) async {
    ApiResult<bool> result = await widget.sportEventEngine.sportService.joinSportEvent(mapEventData);
  }

  Future<void> _onUserButtonRequestSend(UserEventRequestType requestType) async {
    await widget.sportEventEngine.update(force: true);
  }

  void _onDeleteEvent() {
    Navigator.of(context).pop();
    widget.sportEventEngine.update();
  }

}