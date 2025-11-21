import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/map/icon/map_icon.dart';
import 'package:sportm8s/map/models/map_marker_rect.dart';
import 'package:sportm8s/map/models/map_sport_event_marker.dart';

abstract class SportEventRepository
{
  final LoggerService _logger = new LoggerService();
  List<MapMarkerRect> _osmMarkersRects = [];
  UpdateSportEventsResult updateSportEvents(List<MapSportEventData> events);
  void updateOSMMarkerRects(MapMarkerRect mapMarkerRect);
  List<Marker> getOSMMarkers();
  List<MapMarkerRect> getMarkerRects();
  MapSportIconWidgetResult getMapSportIconWidgetBasedOnID(String id);
  List<MapSportIconWidgetResult> getMapSportIconsWidgetBasedOnID(List<String> ids);
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

  @override
  void updateOSMMarkerRects(MapMarkerRect mapMarkerRect) {
    if(!_osmMarkersRects.any((x) => x.iconID == mapMarkerRect.iconID)) {
      _osmMarkersRects.add(mapMarkerRect);
    }
    else{
      final result = _osmMarkersRects.firstWhere((x) => x.iconID == mapMarkerRect.iconID);
      result.rect = mapMarkerRect.rect;
      result.mapIcon = mapMarkerRect.mapIcon;
    }
  }

  @override
  List<MapMarkerRect> getMarkerRects() {
    // TODO: implement getMarkerRects
    return _osmMarkersRects;
  }

  @override
  MapSportIconWidgetResult getMapSportIconWidgetBasedOnID(String id) {
    // TODO: implement getMapSportEventDataBasedOnIDl
    for(int i = 0; i < _osmMarkersRects.length; i++){
      if(_osmMarkersRects.any((x) => x.iconID == id)){
        return MapSportIconWidgetResult(true, _osmMarkersRects[i].mapIcon);
      }
    }

    return MapSportIconWidgetResult(false, null);
  }

  @override
  List<MapSportIconWidgetResult> getMapSportIconsWidgetBasedOnID(List<String> ids) {
    List<MapSportIconWidgetResult> results = [];
    for(int i = 0; i < ids.length; i++){
      MapSportIconWidgetResult result = getMapSportIconWidgetBasedOnID(ids[i]);
      if(result.hasFound){
        results.add(result);
      }
    }
    return results;
  }
}

class UpdateSportEventsResult{
  bool hasChanged;
  UpdateSportEventsResult(this.hasChanged);
}

class MapSportIconWidgetResult{
  bool hasFound;
  MapIcon? mapIcon;
  MapSportIconWidgetResult(this.hasFound, this.mapIcon);
}