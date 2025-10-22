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
    
    LatLng position = LatLng(value['positionLatitude'], value['positionLongitude']);
    SportEventType sportEventType = SportEventUtils.getTypeBasedOnRandomTitle(value['sportEventType']);

    List<String> participantsIDs = value['participantsIDs'] as List<String>;

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
    );

    Marker marker = Marker(point: position, child: markerData.mapIconEvent(eventData));

    mapSportEventDataParsed = MapSportEventData(marker, eventData);

    return mapSportEventDataParsed;
  }
}