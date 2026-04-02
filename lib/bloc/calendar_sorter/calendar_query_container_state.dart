import 'package:sportm8s/calendar/container/calendar_date_range.dart';
import 'package:sportm8s/calendar/widgets/calendar_week_bar.dart';

import '../../core/enums/enums_container.dart';

class CalendarQueryContainerState{
  final SportEventType queriedSportEventType;
  final EventDistanceQueryType queriedEventDistanceType;
  final CalendarBarDateContainer barDateContainer;

  const CalendarQueryContainerState(this.queriedSportEventType , this.queriedEventDistanceType , this.barDateContainer);
}