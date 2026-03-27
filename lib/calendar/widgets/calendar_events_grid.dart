import 'package:flutter/cupertino.dart';
import 'package:sportm8s/calendar/widgets/calendar_events_tile.dart';
import 'package:sportm8s/map/engine/sport_event_repository.dart';

import '../../map/models/map_sport_event_marker.dart';

class CalendarEventsGrid extends StatefulWidget{

  final MainSportEventRepository mainSportEventRepository;
  final Function(CalendarEventsTile) calendarEventsTileClicked;

  const CalendarEventsGrid(this.mainSportEventRepository,this.calendarEventsTileClicked, {super.key});

  @override
  State<StatefulWidget> createState() => _CalendarEventsGrid();
}

class _CalendarEventsGrid extends State<CalendarEventsGrid>{
  @override
  Widget build(BuildContext context) {

    List<MapSportEventData> eventDatas = widget.mainSportEventRepository.getMapSportEventDatas();

    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8
        ),
        itemCount: eventDatas.length,
        itemBuilder: (context, index) {
          return CalendarEventsTile(widget.calendarEventsTileClicked , eventDatas[index]);
        }
    );
  }

}