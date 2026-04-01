import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sportm8s/gen/assets.gen.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/map/models/map_sport_event_marker.dart';

import '../enums/enums_container.dart';

class EventUtility{
  static Image GetEventIconBasedOnEventParam(EventParamType eventParamType , double width, double height){
    switch(eventParamType){
      case EventParamType.EventDate:
        return Image.asset(Assets.icons.events.iconsCalendar.path ,width: width, height: height);
      case EventParamType.EventName:
        // TODO: Handle this case.
        return Image.asset(Assets.icons.events.iconsEventName.path, width: width , height: height);
      case EventParamType.EventDescription:
        // TODO: Handle this case.
        return Image.asset(Assets.icons.events.iconsEventDescription.path, width: width , height: height);
      case EventParamType.EventParticipants:
        // TODO: Handle this case.
        return Image.asset(Assets.icons.events.iconsSportPeople.path, width: width , height: height);
      case EventParamType.EventTime:
        return Image.asset(Assets.icons.events.iconsEventClock.path , width: width , height: height);
    }
  }

  static String getLocalisedEventParamTypeName(EventParamType eventParamType){
    switch(eventParamType){
      case EventParamType.EventDate:
        return "Event Date";
      case EventParamType.EventName:
        // TODO: Handle this case.
        return "Event Name";
      case EventParamType.EventDescription:
        // TODO: Handle this case.
        return "Event Description";
      case EventParamType.EventParticipants:
        // TODO: Handle this case.
        return "Event Participants";
      case EventParamType.EventTime:
        // TODO: Handle this case.
        return "Event Time";
    }
  }

  static String getLocalisedEventRequestTypeName(EventServiceRequestType requestType){
    switch(requestType){
      case EventServiceRequestType.Idle:
        return "Idle nothing to do here";
      case EventServiceRequestType.CreatingEvent:
        return "Create Event Request is being send to server";
      case EventServiceRequestType.JoiningEvent:
        return "Join Event Request is being send to server";
    }
  }

  static Map<String,dynamic> toJson(Map<String,Participant> participants){
    return participants.map((key, value) => MapEntry(key, value.toJson()));
  }

  static List<EventDateTimeContainer> sortMapEventDatasByDay(
      List<MapSportEventData> mapEventDatas,
      ) {
    final now = DateTime.now();

    final sortedList = List<MapSportEventData>.from(mapEventDatas);

    sortedList.sort((a, b) {
      final DateTime aDate = a.eventData.eventStartDate;
      final DateTime bDate = b.eventData.eventStartDate;

      final bool aIsPast = aDate.isBefore(now);
      final bool bIsPast = bDate.isBefore(now);

      // Upcoming first, past after
      if (aIsPast != bIsPast) {
        return aIsPast ? 1 : -1;
      }

      // Upcoming -> nearest first
      if (!aIsPast) {
        return aDate.compareTo(bDate);
      }

      // Past -> most recent past first
      return bDate.compareTo(aDate);
    });

    final List<EventDateTimeContainer> result = [];

    for (final mapSportEventData in sortedList) {
      final DateTime eventDateTime = mapSportEventData.eventData.eventStartDate;

      final DateTime eventDay = DateTime(
        eventDateTime.year,
        eventDateTime.month,
        eventDateTime.day,
      );

      final EventDataTimeType eventDataTimeType =
      eventDateTime.isBefore(now)
          ? EventDataTimeType.Past
          : EventDataTimeType.Upcoming;

      final int existingIndex = result.indexWhere((container) =>
      container.eventDataTimeType == eventDataTimeType &&
          container.eventDateTime.year == eventDay.year &&
          container.eventDateTime.month == eventDay.month &&
          container.eventDateTime.day == eventDay.day);

      if (existingIndex != -1) {
        result[existingIndex].mapEventData.add(mapSportEventData.eventData);
      } else {
        result.add(
          EventDateTimeContainer(
            eventDataTimeType,
            eventDay,
            [mapSportEventData.eventData],
          ),
        );
      }
    }

    return result;
  }

  static List<EventDateTimeContainer> getEventDateTimeContainerWithUserID(List<EventDateTimeContainer> container, String userID){
    List<EventDateTimeContainer> eventDateContainerWithUserID = [];
    for(int i = 0; i< container.length; i++){
      if(container[i].mapEventData.isEmpty){
        continue;
      }

      for(int j = 0; j < container[i].mapEventData.length; j++){
        if(container[i].mapEventData[j].participantsIDs.containsKey(userID)){
          eventDateContainerWithUserID.add(container[i]);
          break;
        }
      }
    }

    return eventDateContainerWithUserID;
  }
}