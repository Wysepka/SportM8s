import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/map/engine/sport_event_controller.dart';
import 'package:sportm8s/map/engine/sport_event_repository.dart';
import 'package:sportm8s/map/map_side_view.dart';
import 'package:sportm8s/services/server_sport_service.dart';
import '../../services/server_service.dart';

class SportEventEngine{
  final SportEventController eventController;
  final ServerSportService sportService;
  final SportEventRepository eventRepository;

  late Timer? updateTimer;

  SportEventEngine(this.eventController , this.sportService , this.eventRepository);

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
}