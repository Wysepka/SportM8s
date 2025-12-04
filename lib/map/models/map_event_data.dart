import 'dart:ffi';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/enums/enums_container.dart';

class MapEventData
{
  final String eventName;
  final String eventDescription;
  final SportEventType sportEventType;
  final LatLng position;
  final int maxParticipants;
  final int currentParticipants;
  final String eventID;
  final String creatorID;
  final List<String> participantsIDs;
  final DateTime eventStartDate;
  final Duration eventDuration;

  const MapEventData({
      required this.eventName,
      required this.eventDescription ,
      required this.sportEventType,
      required this.position ,
      required this.maxParticipants ,
      required this.currentParticipants,
      required this.eventID,
      required this.creatorID,
      required this.participantsIDs,
      required this.eventStartDate,
      required this.eventDuration,
  });

  MapEventData copyProvidePosition(MapEventData mapEventData, LatLng position){
    return MapEventData(
        eventName: mapEventData.eventName,
        eventDescription: mapEventData.eventDescription,
        sportEventType: mapEventData.sportEventType,
        position: position,
        maxParticipants: mapEventData.maxParticipants,
        currentParticipants: mapEventData.currentParticipants,
        eventID: mapEventData.eventID,
        creatorID: mapEventData.creatorID,
        participantsIDs: mapEventData.participantsIDs);
  }
}