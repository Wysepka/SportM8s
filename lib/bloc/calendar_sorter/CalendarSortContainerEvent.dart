import 'package:sportm8s/core/enums/enums_container.dart';

abstract class CalendarSortContainerEvent{}

class CalendarSportEventChangedEvent extends CalendarSortContainerEvent
{
  final SportEventType sportEventType;

  CalendarSportEventChangedEvent(this.sportEventType);
}
class CalendarEventDistanceChangedEvent extends CalendarSortContainerEvent{
  final EventDistanceQueryType eventDistanceQueryType;

  CalendarEventDistanceChangedEvent(this.eventDistanceQueryType);
}