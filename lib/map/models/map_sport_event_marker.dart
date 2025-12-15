import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/utility/sport_utility.dart';
import 'package:sportm8s/map/map_side_view.dart';
import 'package:sportm8s/map/models/map_event_data.dart';

class MapSportEventData
{
  final Marker marker;
  final MapEventData eventData;

  const MapSportEventData(this.marker, this.eventData);

  factory MapSportEventData.fromJson(Map<String,dynamic> value , OSMMarkerData markerData){
    MapSportEventData mapSportEventDataParsed;
    
    LatLng position = LatLng(value['positionLatitude'] as double, value['positionLongitude'] as double);
    SportEventType sportEventType = SportEventUtils.parseIntToSportEventType(value['sportEventType']);

    List<String> participantsIDs = List<String>.from(value['participantsIDs'] ?? []);

    MapEventData eventData = MapEventData(
        eventName: value['eventName'] as String,
        eventDescription: value['eventDescription'] as String,
        sportEventType: sportEventType,
        position: position,
        maxParticipants: value['maxParticipants'],
        currentParticipants: value['currentParticipants'],
        eventID: value['eventID'],
        creatorID: value['creatorID'],
        participantsIDs: participantsIDs,
        eventStartDate: DateTime.parse(value["eventDateTime"]),
        eventDuration: parseTimeOfDay(value["eventTime"]),
    );

    Marker marker = Marker(point: position, child: markerData.mapIconEvent(eventData) , width: 160, height: 360 , alignment: Alignment.bottomCenter);

    mapSportEventDataParsed = MapSportEventData(marker, eventData);

    return mapSportEventDataParsed;
  }

  static TimeOfDay parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}