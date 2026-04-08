import 'package:flutter/material.dart';
import 'package:sportm8s/map/models/map_event_data.dart';

class MapCallbacksContainer{
  final void Function(MapEventData mapEventData) onCreateEventCallback;
  final void Function(MapEventData mapEventData) onJoinEventCallback;
  final Widget Function(MapEventData mapEventData) getMapJoinWidget;
  final MapEventData Function() getCurrentMapEventData;

  MapCallbacksContainer({required this.onCreateEventCallback ,required this.onJoinEventCallback,required this.getMapJoinWidget  , required this.getCurrentMapEventData});
}