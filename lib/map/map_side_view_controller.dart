import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/map/initializers/map_view_initializer.dart';

class MapSideViewController extends ChangeNotifier{
  MapScreenType _mapScreenType = MapScreenType.Invalid;
  MapViewDataContainer mapViewDataContainer = MapViewDataContainer.returnDummy();

  MapScreenType get mapScreenType => _mapScreenType;

  void setMapScreenType(MapScreenType mapScreenType){
    _mapScreenType = mapScreenType;
    notifyListeners();
  }

}