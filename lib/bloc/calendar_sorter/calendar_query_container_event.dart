import 'package:sportm8s/calendar/container/calendar_date_range.dart';
import 'package:sportm8s/calendar/widgets/calendar_week_bar.dart';
import 'package:sportm8s/core/enums/enums_container.dart';

abstract class CalendarQueryContainerEvent{}

class CalendarSportEventChangedEvent extends CalendarQueryContainerEvent
{
  final SportEventType sportEventType;

  CalendarSportEventChangedEvent(this.sportEventType);
}
class CalendarEventDistanceChangedEvent extends CalendarQueryContainerEvent{
  final EventDistanceQueryType eventDistanceQueryType;

  CalendarEventDistanceChangedEvent(this.eventDistanceQueryType);
}
class CalendarEventDateRangeChanged extends CalendarQueryContainerEvent{
  final CalendarBarDateContainer barDateContainer;

  CalendarEventDateRangeChanged(this.barDateContainer);
}