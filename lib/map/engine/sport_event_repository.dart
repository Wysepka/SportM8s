import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/map/icon/map_icon.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/map/models/map_marker_rect.dart';
import 'package:sportm8s/map/models/map_sport_event_marker.dart';

abstract class SportEventRepository
{
  final List<void Function(MapSportEventData)> _changeSportEventSubscribers = [];
  final LoggerService _logger = new LoggerService();
  final List<MapMarkerRect> _osmMarkersRects = [];
  UpdateSportEventsResult updateSportEvents(List<MapSportEventData> events);
  UpdateSportEventsResult forceUpdateSportEvents(List<MapSportEventData> events);
  List<MapSportEventData> getMapSportEventDatas();
  void updateOSMMarkerRects(MapMarkerRect mapMarkerRect);
  List<Marker> getOSMMarkers();
  List<MapMarkerRect> getMarkerRects();
  MapSportIconWidgetResult getMapSportIconWidgetBasedOnID(String id);
  List<MapSportIconWidgetResult> getMapSportIconsWidgetBasedOnID(List<String> ids);
  TryGetMapSportEventData getMapSportEventDataBasedOnID(String id);

  void markMapScreenType(MapScreenType mapScreenType);

  void registerToSportEventsChanged(Function(MapSportEventData) function);
  void unregisterToSportEventsChanged(Function(MapSportEventData) function);

  void rebuildMarkers(Widget Function(MapEventData mapEventData) markerWidget);
}

class MainSportEventRepository extends SportEventRepository
{
  List<void Function(MapSportEventData)> _changeSportEventSubscribers = [];
  List<MapSportEventData> _mapSportEventDatas = [];

  @override
  UpdateSportEventsResult updateSportEvents(List<MapSportEventData> events) {

    List<String> fetchedIDS = events.map((x) => x.eventData.eventID).toList();
    List<String> currentIDs = _mapSportEventDatas.map((x) => x.eventData.eventID).toList();

    List<String> idsToInclude = fetchedIDS.where((e) => !currentIDs.contains(e)).toList();
    List<String> idsToDelete = currentIDs.where((e) => !fetchedIDS.contains(e)).toList();

    for(int i=0; i < idsToDelete.length; i++){
      MapSportEventData eventToDelete = _mapSportEventDatas.where((e) => e.eventData.eventID == idsToDelete[i]).first;
      _mapSportEventDatas.remove(eventToDelete);
    }

    for(int i = 0; i < idsToInclude.length; i++){
      _mapSportEventDatas.add(events.where((e) => e.eventData.eventID == idsToInclude[i]).first);
    }

    return UpdateSportEventsResult(idsToInclude.isNotEmpty || idsToDelete.isNotEmpty);
  }

  @override
  UpdateSportEventsResult forceUpdateSportEvents(List<MapSportEventData> events) {
    _mapSportEventDatas = events;
    return UpdateSportEventsResult(true);
  }

  @override
  List<Marker> getOSMMarkers() {
    List<Marker> markers = [];

    for(int i = 0; i < _mapSportEventDatas.length; i++){
      markers.add(_mapSportEventDatas[i].marker);
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

  @override
  TryGetMapSportEventData getMapSportEventDataBasedOnID(String id) {
    for(int i=0; i < _mapSportEventDatas.length; i++){
      if(_mapSportEventDatas[i].eventData.eventID == id){
        return TryGetMapSportEventData(true, _mapSportEventDatas[i]);
      }
    }
    return TryGetMapSportEventData(false, null);
  }

  @override
  List<MapSportEventData> getMapSportEventDatas() => _mapSportEventDatas;

  @override
  void registerToSportEventsChanged(Function(MapSportEventData p1) function) {
    if(!_changeSportEventSubscribers.contains(function)){
      _changeSportEventSubscribers.add(function);
    }
    else{
      _logger.error("Function: ${function} already registered in _changeSportEventSubscribers");
    }
  }

  @override
  void unregisterToSportEventsChanged(Function(MapSportEventData p1) function) {
    if(_changeSportEventSubscribers.contains(function)){
      _changeSportEventSubscribers.remove(function);
    }
    else{
      _logger.error("Could not unregister function: ${function} , from _changeSportEventSubscribers");
    }
  }

  @override
  void rebuildMarkers(Widget Function(MapEventData mapEventData) markerWidget) {
    for(int i=0; i<_mapSportEventDatas.length; i++){
      final cachedEvent = _mapSportEventDatas[i];
      _mapSportEventDatas[i] = MapSportEventData.rebuild(cachedEvent, cachedEvent.eventData.position, markerWidget(cachedEvent.eventData) );
    }
  }

  @override
  void markMapScreenType(MapScreenType mapScreenType) {
    
  }
}

class TryGetMapSportEventData{
  bool success = false;
  MapSportEventData? data;
  TryGetMapSportEventData(this.success , this.data);
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