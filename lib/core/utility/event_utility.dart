import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sportm8s/gen/assets.gen.dart';

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
}