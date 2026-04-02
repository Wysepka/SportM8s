import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportm8s/bloc/calendar_sorter/calendar_query_container_event.dart';
import 'package:sportm8s/bloc/calendar_sorter/calendar_query_container_state.dart';
import 'package:sportm8s/calendar/container/calendar_date_range.dart';
import 'package:sportm8s/calendar/widgets/calendar_week_bar.dart';
import 'package:sportm8s/core/enums/enums_container.dart';

class CalendarQueryContainerBloc extends Bloc<CalendarQueryContainerEvent , CalendarQueryContainerState>{
  CalendarQueryContainerBloc()
  : super(CalendarQueryContainerState(SportEventType.Invalid, EventDistanceQueryType.All , CalendarBarDateContainer())){
    on<CalendarSportEventChangedEvent>((event, emit) {
      emit(CalendarQueryContainerState(event.sportEventType, state.queriedEventDistanceType , state.barDateContainer));
    });
    on<CalendarEventDistanceChangedEvent>((event, emit){
      emit(CalendarQueryContainerState(state.queriedSportEventType, event.eventDistanceQueryType , state.barDateContainer));
    });
    on<CalendarEventDateRangeChanged>((event, emit){
      emit(CalendarQueryContainerState(state.queriedSportEventType, state.queriedEventDistanceType, event.barDateContainer));
    });
  }
}