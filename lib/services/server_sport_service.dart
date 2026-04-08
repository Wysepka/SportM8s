
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/core/models/cosmos_response.dart';
import 'package:sportm8s/core/models/cosmos_result.dart';
import 'package:sportm8s/core/models/server_response.dart';
import 'package:sportm8s/core/utility/event_utility.dart';
import 'package:sportm8s/dto/api_error.dart';
import 'package:sportm8s/dto/api_result.dart';
import 'package:sportm8s/dto/list_response.dart';
import 'package:sportm8s/dto/user_display_name_id_dto.dart';
import 'package:sportm8s/map/map_side_view.dart';
import 'package:sportm8s/map/models/map_sport_event_marker.dart';
import 'package:sportm8s/services/server_service.dart';

import '../dto/sport_event_dto.dart';
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
  late OSMMarkerDataCallbacks markerData;
  ServerSportService(this.serverService);

  Future<List<MapSportEventData>> fetchUpdate() async {
    logger.info("Started Checking Update from ServerSportService");
    //serverService.getDynamicMap("");
    String continuationToken = "";
    int pageSize = 50;

    var eventsResult = await getSportEventsFromServer(pageSize, continuationToken);

    List<MapSportEventData> events = [];
    if(eventsResult is OkResultPaginated<List<MapSportEventData>>){
      events = (eventsResult).data;
    }

    return events;
  }

  Future<ApiResult<List<MapSportEventData>>> getSportEventsFromServer(int pageSize ,  String continuationToken) async {
    bool firstRun = true;
    List<MapSportEventData> eventsList = [];
    int statusCode = 500;

    while(firstRun || continuationToken.isNotEmpty) {
      // ✅ Send GET request
      final response = await serverService.getDynamicMapPaginated(
          "SportMap/getSportEvents", pageSize: 50,
          continuationToken: continuationToken);

      if(response['okResult'] == null){
        return ErrorResult(
            error: ApiError(
                errorCode: response['statusCode'],
                errorMessage: response['detail']),
            statusCode: response['statusCode']);
      }

      statusCode = response['okResult']['statusCode'];
      final eventsJson = response['okResult']['data'] as List;
      for(int i = 0; i < eventsJson.length; i++)
      {
          MapSportEventData event = MapSportEventData.fromJson(eventsJson[i], markerData);
          eventsList.add(event);
      }

      if(response['okResult']['continuationToken'] != null) {
        continuationToken = response['okResult']['continuationToken'];
      }
      else{
        continuationToken = "";
      }

      firstRun = false;
    }

    return OkResultPaginated(
        data: eventsList,
        continuationToken: continuationToken,
        statusCode: statusCode,
    );
  }

  Future<ApiResult<bool>> addSportEvent(MapEventData mapEventData) async {
    final response = await serverService.post(
      "SportMap/addSportEvent",
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
          "currentParticipants": 1,
        },
        'eventDateTime': mapEventData.eventStartDate.toIso8601String(),
        'eventTime': '${mapEventData.eventDuration.hour.toString().padLeft(2, '0')}:'
            '${mapEventData.eventDuration.minute.toString().padLeft(2, '0')}:00',
      },);

    OkResult<bool> okResult;
    var apiResultCode = response['statusCode'] ?? response['okResult']['statusCode'] as int;
    bool isOkStatusCode = apiResultCode >= 200 && apiResultCode < 299;
    okResult = OkResult(data: isOkStatusCode , statusCode: apiResultCode);
    if(!isOkStatusCode){
      logger.error("Could not Create Sport Event | Error: ${response["detail"]}");
      return ErrorResult(error: response['detail'] ?? response['errorMessage'], statusCode: apiResultCode);
    }
    else {
      return okResult;
    }
  }

  Future<ApiResult<bool>> joinSportEvent(MapEventData mapEventData) async {
    final response = await serverService.patch(
      "SportMap/joinSportEvent",
      body: {
        'eventName': mapEventData.eventName,
        'eventDescription': mapEventData.eventDescription,
        'sportEventType': mapEventData.sportEventType.index,
        'eventID': mapEventData.eventID,
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

    if(response['okResult'] != null){
      return OkResult(data: true, statusCode: 200);
    }

    int statusCode = response['statusCode'] ?? response['errorCode'];
    String errorMsg = response['detail'] ?? response['errorMessage'];

    if(statusCode < 200 || statusCode > 299){
      logger.error("Could not Join Sport Event | Error: ${errorMsg}");
        return ErrorResult(
            error: ApiError(
                errorCode: statusCode,
                errorMessage: errorMsg),
            statusCode: statusCode
        );
    }
    else{
      return OkResult(
          data: false,
          statusCode: statusCode
      );
    }
  }

  Future<ApiResult<bool>> leaveSportEvent(MapEventData mapEventData) async {
    final response = await serverService.patch(
      "SportMap/leaveSportEvent",
      body: {
        'eventName': mapEventData.eventName,
        'eventDescription': mapEventData.eventDescription,
        'sportEventType': mapEventData.sportEventType.index,
        'eventID': mapEventData.eventID,
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

    int statusCode = response['errorCode'] ?? response['okResult']['statusCode'];

    if(statusCode == 500){
      String errorMsg =  response['detail'] ?? response['errorMessage'];
      logger.error("Could not Join Sport Event | Error: ${errorMsg}");
      return ErrorResult(
          error: ApiError(
              errorCode: 500,
              errorMessage: errorMsg),
          statusCode: 500
      );
    }

    if(statusCode >= 200 && statusCode <= 299){
      return OkResult(
          data: true,
          statusCode: statusCode
      );
    }
    else {
      String errorMsg =  response['detail'] ?? response['errorMessage'];
      logger.error("Could not Join Sport Event | Error: ${errorMsg}}");
      return ErrorResult(
          error: ApiError(
              errorCode: response['statusCode'],
              errorMessage: errorMsg
          ),
          statusCode: response['statusCode']
      );
    }
  }


  Future<ApiResult<bool>> deleteSportEvent(MapEventData mapEventData) async {
    final response = await serverService.delete(
      "SportMap/deleteSportEvent/${mapEventData.eventID}",
      body: {
        'eventID': mapEventData.eventID,
      },);
    int statusCode = response['statusCode'] ?? response['okResult']['statusCode'];
    if(statusCode >= 200 && statusCode < 299){
      logger.info("Sport Event with ID:${mapEventData.eventID} deletion went success");
      return OkResult(
          data: true,
          statusCode: statusCode
      );
    }
    else {
      logger.error("Could not Delete Sport Event | Error: ${response["detail"]}");
      return ErrorResult(
          error: ApiError(
              errorCode: response['statusCode'],
              errorMessage: response['detail'] ?? response['errorMessage']
          ),
          statusCode: response['statusCode']
      );
    }
  }

  //Optimize to send only event ID
  Future<ApiResult<ListResponse<UserDisplayNameIDDTO>>> getMapEventParticipantsDisplayNames(MapEventData mapEventData) async {
    final result = await serverService.post("User/getUsersDisplayName",
      body: {
        'eventName': mapEventData.eventName,
        'eventDescription': mapEventData.eventDescription,
        'sportEventType': mapEventData.sportEventType.index,
        'eventID': mapEventData.eventID,
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

    if(result["statusCode"] == 200){
      final dataList = ListResponse.fromJson(result['data'], (e) => UserDisplayNameIDDTO.fromJson(e as Map<String,dynamic>));
      return OkResult(
          data: dataList,
          statusCode: result['statusCode'],
      );
    }
    else{
      String errorMessage = result['detail'];
      logger.error("Could not Retrieve Participants Display Names | Error: ${errorMessage}");
      return ErrorResult(
          error: ApiError(
              errorCode: result['statusCode'],
              errorMessage: errorMessage
          ),
          statusCode: result['statusCode']
      );
    }
  }

  Future<ApiResult<bool>> getIsCurrentUserEventCreator(String mapEventID) async {
    final result = await serverService.getDynamicMap("SportMap/${mapEventID}/isCurrentUserEventCreator");
    int statusCode = result['statusCode'] ?? result['okResult']['statusCode'];
    if(statusCode >= 200 && statusCode <= 299){
      return OkResult(
          data: result['okResult']['data'] as bool,
          statusCode: statusCode
      );
    }
    else {
      return ErrorResult(
          error: ApiError(
              errorCode: statusCode,
              errorMessage: result['detail'] ?? result['errorMessage'],
          ),
          statusCode: statusCode
      );
    }
  }
}