
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:sportm8s/app_consts.dart';
import 'package:sportm8s/core/logger/logger_config.dart';
import 'package:sportm8s/core/utility/random_utility.dart';
import 'package:sportm8s/map/engine/sport_event_controller.dart';
import 'package:sportm8s/map/engine/sport_event_repository.dart';
import 'package:sportm8s/map/map_icon.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/services/server_service.dart';
import 'package:sportm8s/services/server_sport_service.dart';

import 'engine/sport_event_engine.dart';


class MapSideView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MapSideView();
}

class _MapSideView extends State<MapSideView>{
  //_MapSideView({super.key});
  final MapController mapController = new MapController();
  late SportEventEngine sportEventEngine;
  double zoomValue = 0;

  @override void initState() {
    // TODO: implement initState
    super.initState();
    final serverServiceContainer = ProviderScope.containerOf(context , listen: false);
    final serverService = serverServiceContainer.read(serverServiceProvider);
    sportEventEngine = SportEventEngine(SportEventController(), ServerSportService(serverService), FakeSportEventRepository());
    OSMMarkerData markerData = OSMMarkerData(_getMapIconEvent, _getMarkerWidth, _getMarkerHeight, _getZoomMultiplier);
    sportEventEngine.eventController.addListener(onSportEventsChanged);
    sportEventEngine.initialize(markerData);
  }

  void onSportEventsChanged(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(AppConsts.IS_PRODUCTION){
      return Center(child: Text("Production Ready map is not available !"));
    }
    else {
      // TODO: implement build
      return GestureDetector(
          child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                //TODO add LatLng info getting from phone localization
                initialCenter: LatLng(52.237049, 21.017532),
                initialZoom: 13.0,
                onMapEvent: (event) {
                  if(event is MapEventDoubleTapZoomEnd || event is MapEventDoubleTapZoomStart
                  || event is MapEventMoveStart || event is MapEventMoveEnd){
                    setState(() {
                      zoomValue = event.camera.zoom;
                    });
                  }
                }
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                //MarkerLayer(markers: RandomUtility.getMarkers_Test(_getMarkerWidth, _getMarkerHeight, _getMapIcon , _getZoomMultiplier))
                MarkerLayer(markers: sportEventEngine.eventRepository.getOSMMarkers())
            ]
          ),
        );
    }
  }


  Widget _getMapIconEvent(MapEventData mapEventData){
    MapIcon mapIcon = MapIcon(_getZoomMultiplier);
    mapIcon.mapEventData = mapEventData;
    return mapIcon;
  }

  Widget _getMapIcon(double zoomMultiplier){
    MapIcon mapIcon = MapIcon(_getZoomMultiplier);
    return mapIcon;
  }

  double _getMarkerWidth(){
    return 120 * _getZoomMultiplier();
  }

  double _getMarkerHeight(){
    return 180 * _getZoomMultiplier();
  }

  double _getZoomMultiplier(){
    return zoomValue * 0.05;
  }
/*

List<Marker> _getMarkers_Test(){
    List<Marker> markersList = [];
    
    markersList.add(Marker(
      point: LatLng( 52.337049, 21.117532),
      width: _getMarkerWidth(),
      height: _getMarkerHeight(),
      child: _getMarkerChild(),
    ));

    markersList.add(Marker(
      point: LatLng( 52.537049, 21.227532),
      width: _getMarkerWidth(),
      height: _getMarkerHeight(),
      child: _getMarkerChild(),
    ));

    markersList.add(Marker(
      point: LatLng( 52.427049, 21.25532),
      width: _getMarkerWidth(),
      height: _getMarkerHeight(),
      child: _getMarkerChild(),
    ));

    return markersList;
}

Widget _getMarkerChild(){
    String randomString = RandomUtility.randomString(10, 30);
    return GestureDetector(
      //onTap: () => LoggerConfig.logger.log(level: Level.debug , message: "On GestureDetector Tapped");
      onTap: () => log.d("Gesture Detector tapped"),
      child:
      Column(
        children: [
          Icon(Icons.location_on, size: 40 * _getZoomMultiplier(), color: Colors.red),
           ClipRRect(
              borderRadius: BorderRadius.circular(25 * _getZoomMultiplier()),
              child: Container(
                padding: EdgeInsets.all(4 * _getZoomMultiplier()),
                constraints: BoxConstraints(minWidth:  10 * _getZoomMultiplier() , maxWidth:  120 * _getZoomMultiplier() ,minHeight:  10 * _getZoomMultiplier(),maxHeight:  140 * _getZoomMultiplier()),
                child: Text(randomString, style: TextStyle(fontSize: 20 * _getZoomMultiplier()) , textAlign: TextAlign.center,),
                decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.circular(25 * _getZoomMultiplier()) , border: Border.all(color: Colors.cyan ,width:  10 * _getZoomMultiplier())),
          )),
        ],
      ),
    );
}
*/

}

class OSMMarkerData{

  Widget Function(MapEventData mapEventData) mapIconEvent;
  double Function() markerWidth;
  double Function() markerHeight;
  double Function() zoomValue;

  OSMMarkerData(this.mapIconEvent , this.markerWidth , this.markerHeight , this.zoomValue);

}