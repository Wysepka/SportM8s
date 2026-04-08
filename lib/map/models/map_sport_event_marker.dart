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

  factory MapSportEventData.fromJson(Map<String,dynamic> value , OSMMarkerDataCallbacks markerData){
    MapSportEventData mapSportEventDataParsed;
    
    LatLng position;
    if(value['eventPosition']['latitude'] is double && value['eventPosition']['longitude'] is double) {
      position = LatLng(value['eventPosition']['latitude'] as double,
          value['eventPosition']['longitude'] as double);
    }
    else if(value['eventPosition']['latitude'] is int && value['eventPosition']['longitude'] is int){
      position = LatLng((value['eventPosition']['latitude'] as int).toDouble(),
          (value['eventPosition']['longitude'] as int).toDouble());
    }
    else{
      throw Exception("Could not parse EventPosition for Event: ${value['eventName']} , ID: ${value['eventID']}");
    }

    SportEventType sportEventType = SportEventUtils.parseIntToSportEventType(value['sportEventType']);

    final Map<String, Participant> participantsIDs =
    (value['participantsIDs'] as Map<String, dynamic>? ?? {})
        .map(
          (key, val) => MapEntry(
        key,
        Participant.fromJson(val as Map<String, dynamic>),
      ),
    );

    MapEventData eventData = MapEventData(
        eventName: value['eventName'] as String,
        eventDescription: value['eventDescription'] as String,
        sportEventType: sportEventType,
        position: position,
        eventID: value['eventID'],
        creatorID: value['creatorID'],
        participantsIDs: participantsIDs,
        eventStartDate: DateTime.parse(value["eventDateTime"]),
        eventDuration: parseTimeOfDay(value["eventTime"]),
        capacity: Capacity.fromJson(value['capacity']),
    );

    Marker marker = Marker(point: position, child: markerData.mapIconEvent(eventData) , width: 160, height: 360 , alignment: Alignment.bottomCenter);

    mapSportEventDataParsed = MapSportEventData(marker, eventData);

    return mapSportEventDataParsed;
  }

  factory MapSportEventData.rebuild(MapSportEventData other, LatLng position , Widget iconWidget){
    Marker marker = Marker(point: position, child: iconWidget , width: 160 , height: 360, alignment: Alignment.bottomCenter);
    return MapSportEventData(marker, other.eventData);
  }

  static TimeOfDay parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}