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
    }
  }
}