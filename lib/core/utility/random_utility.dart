import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/utility/location_utility.dart';
import 'package:sportm8s/core/utility/sport_utility.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/map/models/map_sport_event_marker.dart';
import 'package:uuid/uuid.dart';

class RandomUtility{

  static final Random _random = Random();
  /// Generates a random integer between [min] (inclusive) and [max] (inclusive).
  ///
  /// Example:
  /// ```dart
  /// final value = RandomUtils.randomInt(1, 10);
  /// print(value); // e.g. 7
  /// ```
  static int randomInt(int min, int max) {
    assert(min <= max, 'min should be <= max');
    return min + _random.nextInt(max - min + 1);
  }

  /// Generates a random string of length between [minLength] and [maxLength].
  /// Uses alphanumeric characters (both upper- and lower-case) by default.
  ///
  /// Example:
  /// ```dart
  /// final str = RandomUtils.randomString(5, 12);
  /// print(str); // e.g. "aZ3fT9"
  /// ```
  static String randomString(int minLength, int maxLength) {
    assert(minLength >= 0 && maxLength >= minLength,
    'minLength should be >= 0 and <= maxLength');

    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        'abcdefghijklmnopqrstuvwxyz'
        '0123456789';

    final length = randomInt(minLength, maxLength);
    return List.generate(length, (_) => _chars[_random.nextInt(_chars.length)])
        .join();
  }

  static List<MapSportEventData> getMarkers_TestEvents(int iterations, double Function() getMarkerWidth , double Function() getMarkerHeight , Widget Function() getMarkerChild){
    List<MapSportEventData> mapSportEventDatas = [];

    /*
    MapEventData event1 = generateRandomMapEventData();

    Marker marker1 = Marker(
      point: LocationUtility.randomLatLngInEuropeCountry("Poland"),
      width: getMarkerWidth(),
      height: getMarkerHeight(),
      child: getMarkerChild(),
    );

    mapSportEventDatas.add(MapSportEventData(marker1, event1));

    MapEventData event2 = generateRandomMapEventData();

    Marker marker2 = Marker(
      point: LocationUtility.randomLatLngInEuropeCountry(countryKey),
      width: getMarkerWidth(),
      height: getMarkerHeight(),
      child: getMarkerChild(),
    );

    mapSportEventDatas.add(MapSportEventData(marker2,event2));

    Marker marker3 = Marker(
      point: LatLng( 52.427049, 21.25532),
      width: getMarkerWidth(),
      height: getMarkerHeight(),
      child: getMarkerChild(),
    );

    MapSportEventData event3 = generateRandomMapEventData();
     */

    //TODO add position the same as in marker in event data
    for(int i = 0; i < iterations; i++)
    {
      Marker marker = Marker(
        point: LocationUtility.randomLatLngInEuropeCountry("Poland") ,
        width: getMarkerWidth(),
        height: getMarkerHeight(),
        child: getMarkerChild(),
      );

      MapEventData mapEventData = generateRandomMapEventData();

      MapSportEventData sportEventData = MapSportEventData(marker, mapEventData);

      mapSportEventDatas.add(sportEventData);
    }

    return mapSportEventDatas;
  }

  static List<Marker> getMarkers_Test(double Function() getMarkerWidth , double Function() getMarkerHeight, Widget Function(double zoomMultiplier) getMarkerChild , double Function() getZoomMultiplier ){
    List<Marker> markersList = [];

    markersList.add(Marker(
      point: LatLng( 52.337049, 21.117532),
      width: getMarkerWidth(),
      height: getMarkerHeight(),
      child: getMarkerChild(getZoomMultiplier()),
    ));

    markersList.add(Marker(
      point: LatLng( 52.537049, 21.227532),
      width: getMarkerWidth(),
      height: getMarkerHeight(),
      child: getMarkerChild(getZoomMultiplier()),
    ));

    markersList.add(Marker(
      point: LatLng( 52.427049, 21.25532),
      width: getMarkerWidth(),
      height: getMarkerHeight(),
      child: getMarkerChild(getZoomMultiplier()),
    ));

    return markersList;
  }

  static MapEventData generateRandomMapEventData()
  {
    String eventTitle = generateRandomEventTitle();
    String eventDescr = generateRandomEventDescription();
    SportEventType eventType = SportEventUtils.getTypeBasedOnRandomTitle(eventTitle);
    LatLng position = LocationUtility.randomLatLngInEuropeCountry("Poland");
    (int min, int max) participants = SportEventUtils.getRandomParticipants(eventType);
    int currParticipants = participants.$1;
    int maxParticipants = participants.$2;
    DateTime dateTime = DateTime.now();
    TimeOfDay timeOfDay = TimeOfDay.now();

    return MapEventData(
        eventName: eventTitle,
        eventDescription: eventDescr,
        sportEventType: eventType,
        position: position,
        capacity: Capacity(maxParticipants: maxParticipants, currentParticipants: currParticipants),
        eventID: Uuid().v4(),
        creatorID: Uuid().v4(),
        participantsIDs: <String,Participant>{},
        eventStartDate: dateTime,
        eventDuration: timeOfDay);
  }

  static SportEventType getTypeBasedOnRandomTitle(String sportTitle) {
    sportTitle = sportTitle.toLowerCase();

    if (sportTitle.contains('football') || sportTitle.contains('soccer')) {
      return SportEventType.Soccer;
    } else if (sportTitle.contains('basketball')) {
      return SportEventType.Basketball;
    } else if (sportTitle.contains('tennis')) {
      return SportEventType.Tennis;
    } else if (sportTitle.contains('volleyball')) {
      return SportEventType.Volleyball;
    } else if (sportTitle.contains('running') || sportTitle.contains('marathon')) {
      return SportEventType.Running;
    } else {
      return SportEventType.Invalid;
    }
  }


  /// Generates a random sport event title, around 20 characters max.
  static String generateRandomEventTitle() {
    final sports = [
      'Football', 'Basketball', 'Tennis', 'Volleyball', 'Hockey',
      'Baseball', 'Rugby', 'Cricket', 'Cycling', 'Running'
    ];
    final adjectives = [
      'Championship', 'League', 'Cup', 'Showdown', 'Battle',
      'Final', 'Tournament', 'Series', 'Open', 'Derby'
    ];
    final locations = [
      'Warsaw', 'London', 'Paris', 'New York', 'Berlin',
      'Madrid', 'Tokyo', 'Sydney', 'Rome', 'Chicago'
    ];

    final rand = Random();
    String title = '${sports[rand.nextInt(sports.length)]} '
        '${adjectives[rand.nextInt(adjectives.length)]} '
        '${locations[rand.nextInt(locations.length)]}';

    // Trim to 20 chars if longer
    return title.length > 20 ? title.substring(0, 20) : title;
  }

  /// Generates a random sport event description, around 100 characters max.
  static String generateRandomEventDescription() {
    final sentences = [
      'Join us for an unforgettable match filled with energy and excitement.',
      'Teams from around the world will compete for glory and honor.',
      'Get ready for intense moments, surprising plays, and great sportsmanship.',
      'Witness the clash of champions in this year’s most anticipated sports event.',
      'Fans will gather to cheer for their favorite teams and celebrate victory.'
    ];

    final rand = Random();
    String desc = '';
    while (desc.length < 90) {
      desc += (desc.isNotEmpty ? ' ' : '') +
          sentences[rand.nextInt(sentences.length)];
    }

    // Limit to 100 chars
    return desc.length > 100 ? desc.substring(0, 100) : desc;
  }
}