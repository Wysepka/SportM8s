
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/map/map_side_view.dart';
import 'package:sportm8s/map/models/map_sport_event_marker.dart';
import 'package:sportm8s/services/server_service.dart';

final serverSportServiceProvider = Provider((ref) {
  final serverService = ref.read(serverServiceProvider);
  return ServerSportService(serverService);
});

class ServerSportService
{
  final LoggerService logger = LoggerService();
  final ServerService serverService;
  bool isUpdating = false;
  late final OSMMarkerData markerData;
  ServerSportService(this.serverService);

  Future<List<MapSportEventData>> fetchUpdate() async {
    logger.info("Started Checking Update from ServerSportService");
    serverService.getDynamicMap("");
    String? continuationToken;
    int pageSize = 50;

    List<MapSportEventData> events = await getSportEventsFromServer(50, continuationToken);

    return events;
  }

  Future<List<MapSportEventData>> getSportEventsFromServer(int pageSize ,  String? continuationToken) async {
    bool firstRun = true;
    List<MapSportEventData> eventsList = [];
    while(firstRun || continuationToken!.isNotEmpty) {
      // ✅ Send GET request
      final response = await serverService.getDynamicMapPaginated(
          "SportMap/getSportEvents", pageSize: 50,
          continuationToken: continuationToken);

      final eventsJson = response['items'] as List;
      for(int i = 0; i < eventsJson.length; i++)
      {
          MapSportEventData event = MapSportEventData.fromJson(eventsJson[i], markerData);
          eventsList.add(event);
      }

      continuationToken = response['continuationToken'];


      firstRun = false;
    }

    return eventsList;
  }

}