import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/core/utility/location_utility.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

class MapViewDataContainer extends ChangeNotifier{
  LatLng position;
  double rotation;
  Style? style;
  bool locationIntialized;
  bool styleInitialized;
  double currentZoom = 13;

  void setMapPosition(LatLng position){
    this.position = position;
    notifyListeners();
  }

  void setMapZoom(double zoom){
    currentZoom = zoom;
    notifyListeners();
  }

  void setMapRotation(double rotation){
    this.rotation = rotation;
    notifyListeners();
  }

  MapViewDataContainer(this.position,this.style , this.locationIntialized , this.styleInitialized , this.rotation);

  factory MapViewDataContainer.returnDummy(){
    return MapViewDataContainer(LocationUtility.defaultPosition , null , false ,false , 0);
  }
}

class MapViewDataController extends ChangeNotifier{



}

class MapViewInitializer{
  final LoggerService loggerService;

  MapViewInitializer(this.loggerService);

  Future<MapViewDataContainer> initializeMapData() async {
    try {
      final location = await LocationUtility.loadCurrentUserLocation(loggerService);
      LatLng initialLocation = location;
      loggerService.info("Current user location initialized properly");

      bool locationInitialized = true;

      final style = await loadMapStyle();
      // store style somewhere if needed
      final darkStyle = style;
      loggerService.info("Map style loaded properly");

      bool styleInitialized = true;

      return MapViewDataContainer(location, style, locationInitialized , styleInitialized , 0);

    } catch (e) {
      loggerService.error("Initialization error: $e");

      rethrow;
    }
  }

  Future<Style> loadMapStyle() => StyleReader(
    uri: 'https://maps.sportm8s.app/styles/sportm8s-dark/style.json',
    // apiKey: '', // not needed for your own server
  ).read();
}