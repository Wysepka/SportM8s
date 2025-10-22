import 'dart:ffi';

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

  const MapEventData({
      required this.eventName,
      required this.eventDescription ,
      required this.sportEventType,
      required this.position ,
      required this.maxParticipants ,
      required this.currentParticipants,
      required this.eventID,
      required this.creatorID,
      required this.participantsIDs});
}