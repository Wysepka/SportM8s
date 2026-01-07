import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/enums/enums_container.dart';

class MapEventData
{
  final String eventName;
  final String eventDescription;
  final SportEventType sportEventType;
  final LatLng position;
  final Capacity capacity;
  final String eventID;
  final String creatorID;
  final Map<String , Participant> participantsIDs;
  final DateTime eventStartDate;
  final TimeOfDay eventDuration;

  const MapEventData({
      required this.eventName,
      required this.eventDescription ,
      required this.sportEventType,
      required this.position ,
      required this.eventID,
      required this.creatorID,
      required this.participantsIDs,
      required this.eventStartDate,
      required this.eventDuration,
      required this.capacity,
  });

  MapEventData copyProvidePosition(MapEventData mapEventData, LatLng position){
    return MapEventData(
        eventName: mapEventData.eventName,
        eventDescription: mapEventData.eventDescription,
        sportEventType: mapEventData.sportEventType,
        position: position,
        eventID: mapEventData.eventID,
        creatorID: mapEventData.creatorID,
        participantsIDs: mapEventData.participantsIDs,
        eventStartDate: mapEventData.eventStartDate,
        eventDuration: mapEventData.eventDuration,
        capacity: mapEventData.capacity,
    );
  }
}

class Capacity{
  final int maxParticipants;
  final int currentParticipants;

  Capacity({required this.maxParticipants , required this.currentParticipants});
  
  factory Capacity.fromJson(Map<String, dynamic> json){
    return Capacity(maxParticipants: json['maxParticipants'], currentParticipants: json['currentParticipants']);
  }
}

class Participant{
  final String participantID;
  final bool isConfirmed;
  final DateTime joinedAt;

  Participant({required this.participantID , required this.isConfirmed , required this.joinedAt});

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      participantID: json['participantID'] as String,
      isConfirmed: json['isConfirmed'] as bool,
      joinedAt: DateTime.parse(json['joinedAt'] as String).toLocal(), // ✅
    );
  }

  Map<String,dynamic> toJson() =>
  {
    'participantID': participantID,
    'isConfirmed': isConfirmed,
    'joinedAt': joinedAt.toUtc().toIso8601String(),
  };
}