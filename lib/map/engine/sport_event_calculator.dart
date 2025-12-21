import 'dart:ui';

import 'package:flutter_map/flutter_map.dart';
import 'package:sportm8s/map/engine/sport_event_repository.dart';
import 'package:sportm8s/map/models/map_marker_rect.dart';

class SportEventCalculator{
  List<MapMarkerRect> returnSportEventsRectsColliding(List<MapMarkerRect> panelRects , LatLngBounds mapBounds) {
    final ids = panelRects.map((x) => x.iconID).toList();
    late List<MapMarkerRect> collidingMapIcons = [];

    for (int i = 0; i < ids.length; i++) {
      for (int j = i + 1; j < ids.length; j++) {
        final idA = ids[i];
        final idB = ids[j];
        final rectA = panelRects.firstWhere((x) => x.iconID == idA).rect;
        final rectB = panelRects.firstWhere((x) => x.iconID == idB).rect;

        final mapIconA = panelRects.firstWhere((x) => x.iconID == idA);
        final mapIconB = panelRects.firstWhere((x) => x.iconID == idB);

        final bool overlaps = rectA.overlaps(rectB);
        final bool aInsideB = _isRectInside(rectA, rectB);
        final bool bInsideA = _isRectInside(rectB, rectA);

        bool isARendered = mapBounds.contains(mapIconA.mapIcon.mapEventData.position);
        bool isBRendered = mapBounds.contains(mapIconB.mapIcon.mapEventData.position);

        if(mapIconA.mapIcon.mapEventData.eventName == "jvyjb" || mapIconB.mapIcon.mapEventData.eventName == "jvyjb"){
          final s = 's';
        }

        mapIconA.mapIcon.controller.setRendered(isARendered);
        mapIconB.mapIcon.controller.setRendered(isBRendered);

        bool mapIconARendered = mapIconA.mapIcon.controller.isRendered;
        bool mapIconBRendered = mapIconB.mapIcon.controller.isRendered;

        bool anyNotRendered = !mapIconBRendered || !mapIconARendered;

        if (overlaps && !anyNotRendered) {
          if (!collidingMapIcons.contains(idA)) {
            collidingMapIcons.add(mapIconA);
          }
          if (!collidingMapIcons.contains(idB)) {
            collidingMapIcons.add(mapIconB);
          }
          continue;
        }
        if (aInsideB && !anyNotRendered) {
          if (!collidingMapIcons.contains(idA)) {
            collidingMapIcons.add(mapIconA);
          }
          if (!collidingMapIcons.contains(idB)) {
            collidingMapIcons.add(mapIconB);
          }
          continue;
        }
        if (bInsideA && !anyNotRendered) {
          if (!collidingMapIcons.contains(idA)) {
            collidingMapIcons.add(mapIconA);
          }
          if (!collidingMapIcons.contains(idB)) {
            collidingMapIcons.add(mapIconB);
          }
          continue;
          //panelRects.firstWhere((x) => x.iconID == idA).mapIcon.controller.setColliding(true);
          //panelRects.firstWhere((x) => x.iconID == idB).mapIcon.controller.setColliding(true);
        }
      }
    }
    return collidingMapIcons;
  }

  void toggleCollisionProperties(List<MapMarkerRect> collidingMarkers , List<MapMarkerRect> allMarkers){
    for(int i = 0; i < collidingMarkers.length; i++){
      collidingMarkers[i].mapIcon.controller.setColliding(true);
    }
    for(int i = 0; i < allMarkers.length; i++){
      if(collidingMarkers.any((x) => x.iconID == allMarkers[i].iconID)){
        continue;
      }
      allMarkers[i].mapIcon.controller.setColliding(false);
    }
  }

  bool _isRectInside(Rect inner, Rect outer) {
    return outer.contains(inner.topLeft) && outer.contains(inner.bottomRight);
  }

}