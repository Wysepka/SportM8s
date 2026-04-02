import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportm8s/bloc/calendar_sorter/CalendarSortContainerEvent.dart';
import 'package:sportm8s/bloc/calendar_sorter/CalendarSortContainerState.dart';
import 'package:sportm8s/core/enums/enums_container.dart';

class CalendarQueryContainerBloc extends Bloc<CalendarSortContainerEvent , CalendarQueryContainerState>{
  CalendarQueryContainerBloc()
  : super(CalendarQueryContainerState(SportEventType.Invalid, EventDistanceQueryType.All)){
    on<CalendarSportEventChangedEvent>((event, emit) {
      emit(CalendarQueryContainerState(event.sportEventType, state.queriedEventDistanceType));
    });
    on<CalendarEventDistanceChangedEvent>((event, emit){
      emit(CalendarQueryContainerState(state.queriedSportEventType, event.eventDistanceQueryType));
    });
  }
}