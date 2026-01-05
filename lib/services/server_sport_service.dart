
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/core/models/cosmos_response.dart';
import 'package:sportm8s/core/models/cosmos_result.dart';
import 'package:sportm8s/core/models/server_response.dart';
import 'package:sportm8s/core/utility/event_utility.dart';
import 'package:sportm8s/dto/list_response.dart';
import 'package:sportm8s/map/map_side_view.dart';
import 'package:sportm8s/map/models/map_sport_event_marker.dart';
import 'package:sportm8s/services/server_service.dart';

import '../map/models/map_event_data.dart';

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
    //serverService.getDynamicMap("");
    String continuationToken = "";
    int pageSize = 50;

    List<MapSportEventData> events = await getSportEventsFromServer(pageSize, continuationToken);

    return events;
  }

  Future<List<MapSportEventData>> getSportEventsFromServer(int pageSize ,  String continuationToken) async {
    bool firstRun = true;
    List<MapSportEventData> eventsList = [];
    while(firstRun || continuationToken.isNotEmpty) {
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

      if(response["continuationToken"] != null) {
        continuationToken = response['continuationToken'];
      }
      else{
        continuationToken = "";
      }

      firstRun = false;
    }

    return eventsList;
  }

  Future<CosmosResponse> addSportEvent(MapEventData mapEventData) async {
    final response = await serverService.post(
      "SportMap/addSportEvent",
      body: {
        'eventName': mapEventData.eventName,
        'eventDescription': mapEventData.eventDescription,
        'sportEventType': mapEventData.sportEventType.index,
        'eventPosition':
        {
          'latitude': mapEventData.position.latitude,
          'longitude': mapEventData.position.latitude,
        },
        'capacity':
        {
          "maxParticipants": mapEventData.capacity.maxParticipants,
          "currentParticipants": 1,
        },
        'eventDateTime': mapEventData.eventStartDate.toIso8601String(),
        'eventTime': '${mapEventData.eventDuration.hour.toString().padLeft(2, '0')}:'
            '${mapEventData.eventDuration.minute.toString().padLeft(2, '0')}:00',
      },);
    if(response["statusCode"] == 500){
      logger.error("Could not Create Sport Event | Error: ${response["detail"]}");
      return CosmosResponse.fromJson(response, false);
    }
    else {
      return CosmosResponse.fromJson(response , true);
    }
  }

  Future<CosmosResponse> joinSportEvent(MapEventData mapEventData) async {
    final response = await serverService.post(
      "SportMap/joinSportEvent",
      body: {
        'eventName': mapEventData.eventName,
        'eventDescription': mapEventData.eventDescription,
        'sportEventType': mapEventData.sportEventType.index,
        'eventPosition':
        {
          'latitude': mapEventData.position.latitude,
          'longitude': mapEventData.position.latitude,
        },
        'capacity':
        {
          "maxParticipants": mapEventData.capacity.maxParticipants,
          "currentParticipants": mapEventData.capacity.currentParticipants,
        },
        'eventDateTime': mapEventData.eventStartDate.toIso8601String(),
        'eventTime': '${mapEventData.eventDuration.hour.toString().padLeft(2, '0')}:'
            '${mapEventData.eventDuration.minute.toString().padLeft(2, '0')}:00',
      },);
    if(response["statusCode"] == 500){
      logger.error("Could not Join Sport Event | Error: ${response["detail"]}");
      return CosmosResponse.fromJson(response, false);
    }
    else {
      return CosmosResponse.fromJson(response , true);
    }
  }

  Future<CosmosResponse> leaveSportEvent(MapEventData mapEventData) async {
    final response = await serverService.post(
      "SportMap/joinSportEvent",
      body: {
        'eventName': mapEventData.eventName,
        'eventDescription': mapEventData.eventDescription,
        'sportEventType': mapEventData.sportEventType.index,
        'eventPosition':
        {
          'latitude': mapEventData.position.latitude,
          'longitude': mapEventData.position.latitude,
        },
        'capacity':
        {
          "maxParticipants": mapEventData.capacity.maxParticipants,
          "currentParticipants": mapEventData.capacity.currentParticipants,
        },
        'eventDateTime': mapEventData.eventStartDate.toIso8601String(),
        'eventTime': '${mapEventData.eventDuration.hour.toString().padLeft(2, '0')}:'
            '${mapEventData.eventDuration.minute.toString().padLeft(2, '0')}:00',
      },);
    if(response["statusCode"] == 500){
      logger.error("Could not Join Sport Event | Error: ${response["detail"]}");
      return CosmosResponse.fromJson(response, false);
    }
    else {
      return CosmosResponse.fromJson(response , true);
    }
  }


  Future<bool> deleteSportEvent(MapEventData mapEventData) async {
    final response = await serverService.delete(
      "SportMap/deleteSportEvent/${mapEventData.eventID}",
      body: {
        'eventID': mapEventData.eventID,
      },);
    if(response["result"] as bool){
      logger.info("Sport Event with ID:${mapEventData.eventID} deletion went success");
      return true;
    }
    else {
      logger.error("Could not Delete Sport Event");
      return false;
    }
  }

  //Optimize to send only event ID
  Future<ListResponse<String>> getMapEventParticipantsDisplayNames(MapEventData mapEventData) async {
    final result = await serverService.post("User/getUsersDisplayName",
      body: {
        'eventName': mapEventData.eventName,
        'eventDescription': mapEventData.eventDescription,
        'sportEventType': mapEventData.sportEventType.index,
        'eventPosition':
        {
          'latitude': mapEventData.position.latitude,
          'longitude': mapEventData.position.longitude,
        },
        'capacity':
        {
          "maxParticipants": mapEventData.capacity.maxParticipants,
          "currentParticipants": mapEventData.capacity.currentParticipants,
        },
        'eventDateTime': mapEventData.eventStartDate.toIso8601String(),
        'eventTime': '${mapEventData.eventDuration.hour.toString().padLeft(2, '0')}:'
            '${mapEventData.eventDuration.minute.toString().padLeft(2, '0')}:00',
        'participantsIDs': EventUtility.toJson(mapEventData.participantsIDs),
      },);
    if(result["response"] == "Success"){
      final response = ListResponse.fromJson(result, (e) => e as String);
      return response;
    }
    else{
      logger.error("Could not Retrieve Participants Display Names | Error: ${result["response"]}");
      return ListResponse<String>(items: [] , reason: result["response"]);
    }
    return ListResponse<String>(items: [] , reason: "Error");
  }

  Future<bool> getIsCurrentUserEventCreator(String mapEventID) async {
    final result = await serverService.getDynamicMap("SportMap/${mapEventID}/isCurrentUserEventCreator");
    return result['isCreator'] as bool;
  }
}