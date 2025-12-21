import 'dart:async';
import 'dart:ui';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/logger/logger_config.dart';
import 'package:sportm8s/map/engine/sport_event_calculator.dart';
import 'package:sportm8s/map/engine/sport_event_controller.dart';
import 'package:sportm8s/map/engine/sport_event_repository.dart';
import 'package:sportm8s/map/map_side_view.dart';
import 'package:sportm8s/map/models/map_marker_rect.dart';
import 'package:sportm8s/services/server_sport_service.dart';
import '../../core/logger/logger_service.dart';
import '../../services/server_service.dart';

class SportEventEngine{
  final LoggerService _logger = LoggerService();
  final SportEventController eventController;
  final ServerSportService sportService;
  final SportEventRepository eventRepository;
  final SportEventCalculator eventCalculator;

  late Timer? updateTimer;

  SportEventEngine(this.eventController , this.sportService , this.eventRepository, this.eventCalculator);

  void initialize(OSMMarkerData markerData){
    sportService.markerData = markerData;
    updateTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      update();
    });
  }

  void dispose(){
    if(updateTimer != null) {
      updateTimer?.cancel();
      updateTimer = null;
    }
  }

  void update() async {
    final sportEvents = await sportService.fetchUpdate();
    final updateResult = eventRepository.updateSportEvents(sportEvents);

    if(updateResult.hasChanged){
      eventController.onSportEventChanged();
    }
  }

  void updateRects(MapMarkerRect mapMarkerRect , LatLngBounds mapBounds){
    eventRepository.updateOSMMarkerRects(mapMarkerRect);
    List<MapMarkerRect> rects = eventRepository.getMarkerRects();
    final collidingMarkers = eventCalculator.returnSportEventsRectsColliding(rects , mapBounds);
    eventCalculator.toggleCollisionProperties(collidingMarkers, rects);
    if(collidingMarkers.isNotEmpty){
      _logger.info("Found CollidingMarkers Count: ${collidingMarkers.length}");
    }
  }

  void updateRectsNoAddition(LatLngBounds mapBounds){
    List<MapMarkerRect> rects = eventRepository.getMarkerRects();
    final collidingMarkers = eventCalculator.returnSportEventsRectsColliding(rects , mapBounds);
    eventCalculator.toggleCollisionProperties(collidingMarkers, rects);
    if(collidingMarkers.isNotEmpty) {
      _logger.info("Found CollidingMarkers Count: ${collidingMarkers.length}");
    }
  }
}