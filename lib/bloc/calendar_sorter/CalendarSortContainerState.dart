import '../../core/enums/enums_container.dart';

class CalendarQueryContainerState{
  final SportEventType queriedSportEventType;
  final EventDistanceQueryType queriedEventDistanceType;

  const CalendarQueryContainerState(this.queriedSportEventType , this.queriedEventDistanceType);
}