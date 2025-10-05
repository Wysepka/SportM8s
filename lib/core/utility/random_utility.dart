import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

  static List<Marker> getMarkers_TestEvents(double Function() getMarkerWidth , double Function() getMarkerHeight , Widget Function() getMarkerChild){
    List<Marker> markersList = [];

    markersList.add(Marker(
      point: LatLng( 52.337049, 21.117532),
      width: getMarkerWidth(),
      height: getMarkerHeight(),
      child: getMarkerChild(),
    ));

    markersList.add(Marker(
      point: LatLng( 52.537049, 21.227532),
      width: getMarkerWidth(),
      height: getMarkerHeight(),
      child: getMarkerChild(),
    ));

    markersList.add(Marker(
      point: LatLng( 52.427049, 21.25532),
      width: getMarkerWidth(),
      height: getMarkerHeight(),
      child: getMarkerChild(),
    ));

    return markersList;
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


  /// Generates a random sport event title, around 20 characters max.
  String generateRandomEventTitle() {
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
  String generateRandomEventDescription() {
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