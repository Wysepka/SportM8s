import 'dart:ffi';

import 'package:flutter_map/flutter_map.dart';
import 'package:sportm8s/map/models/map_sport_event_marker.dart';

abstract class SportEventRepository
{
  UpdateSportEventsResult updateSportEvents(List<MapSportEventData> events);
  List<Marker> getOSMMarkers();
}

class FakeSportEventRepository extends SportEventRepository
{
  final List<MapSportEventData> mapSportEventDatas = [];

  @override
  UpdateSportEventsResult updateSportEvents(List<MapSportEventData> events) {

    List<String> fetchedIDS = events.map((x) => x.eventData.eventID).toList();
    List<String> currentIDs = mapSportEventDatas.map((x) => x.eventData.eventID).toList();

    List<String> idsToInclude = fetchedIDS.where((e) => !currentIDs.contains(e)).toList();
    List<String> idsToDelete = currentIDs.where((e) => !fetchedIDS.contains(e)).toList();

    for(int i=0; i < idsToDelete.length; i++){
      MapSportEventData eventToDelete = mapSportEventDatas.where((e) => e.eventData.eventID == idsToDelete[i]).first;
      mapSportEventDatas.remove(eventToDelete);
    }

    for(int i = 0; i < idsToInclude.length; i++){
      mapSportEventDatas.add(events.where((e) => e.eventData.eventID == idsToInclude[i]).first);
    }

    return UpdateSportEventsResult(idsToInclude.isNotEmpty || idsToDelete.isNotEmpty);
  }

  @override
  List<Marker> getOSMMarkers() {
    List<Marker> markers = [];

    for(int i = 0; i < mapSportEventDatas.length; i++){
      markers.add(mapSportEventDatas[i].marker);
    }

    return markers;
  }

}

class UpdateSportEventsResult{
  bool hasChanged;
  UpdateSportEventsResult(this.hasChanged);
}