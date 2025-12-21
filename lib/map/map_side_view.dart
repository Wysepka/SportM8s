
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:sportm8s/app_consts.dart';
import 'package:sportm8s/core/logger/logger_config.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/core/models/cosmos_response.dart';
import 'package:sportm8s/core/utility/random_utility.dart';
import 'package:sportm8s/map/engine/sport_event_calculator.dart';
import 'package:sportm8s/map/engine/sport_event_controller.dart';
import 'package:sportm8s/map/engine/sport_event_repository.dart';
import 'package:sportm8s/map/icon/map_icon.dart';
import 'package:sportm8s/map/icon/map_icon_controller.dart';
import 'package:sportm8s/map/icon/map_icon_create_event.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/map/models/map_marker_rect.dart';
import 'package:sportm8s/services/server_service.dart';
import 'package:sportm8s/services/server_sport_service.dart';

import '../core/models/server_response.dart';
import '../events/map_create_event.dart';
import 'engine/sport_event_engine.dart';


class MapSideView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MapSideView();
}

class _MapSideView extends State<MapSideView>{
  //_MapSideView({super.key});
  LoggerService loggerService = LoggerService();
  final MapController mapController = new MapController();
  late SportEventEngine sportEventEngine;
  late SportEventCalculator sportEventCalculator;
  bool _isCreatingEvent = false;
  double zoomValue = 0;
  LatLng _currentCenteredPosition = LatLng(0, 0);
  LatLng _currentMapIconCreateEventPosition = LatLng(0, 0);
  Point<double> _currentMapPixelsSize = Point(0, 0);
  bool _isSendingEvent = false;

  late MapIconCreateEvent mapIconCreateEvent;

  @override void initState() {
    // TODO: implement initState
    super.initState();
    final serverServiceContainer = ProviderScope.containerOf(context , listen: false);
    final serverService = serverServiceContainer.read(serverServiceProvider);
    final sportEventController = SportEventController();
    sportEventCalculator = SportEventCalculator();
    sportEventController.addListener(refreshMarkers);

    sportEventEngine = SportEventEngine(sportEventController, ServerSportService(serverService), FakeSportEventRepository() ,sportEventCalculator);
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
      return Stack(
        children: [
          Positioned.fill(
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
                        sportEventEngine.updateRectsNoAddition(mapController.camera.visibleBounds);
                        _currentCenteredPosition = event.camera.center;
                        _currentMapPixelsSize = event.camera.size;
                        double offsetByPxInHeight = _currentMapPixelsSize.y * -0.25;
                        _currentMapIconCreateEventPosition = offsetPositionByPixels(_currentCenteredPosition, 0, offsetByPxInHeight);
                      });
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),
                  //MarkerLayer(markers: RandomUtility.getMarkers_Test(_getMarkerWidth, _getMarkerHeight, _getMapIcon , _getZoomMultiplier))
                  MarkerLayer(markers:_getMarkers())
              ]
            ),
          ),

          if(_isCreatingEvent)...[
            MapCreateEventPanel(_onDismissCreateEvent , _applyCreateEvent ,sportEventEngine.sportService),
          ]
          else...[
             Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.yellow,
                  ),
                  icon: Icon(Icons.add, size: 35),
                  onPressed: _onCreateEventTap,
                  //TODO Add localisation
                  label: Text("Create Event")),
              ),
            )
          ],

          if(_isSendingEvent)...[
            Positioned.fill(
                child: IgnorePointer(
                  ignoring: true,
                  child: Container(
                    color: Colors.white38.withOpacity(0.5),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          Text("Sport Event is send to server")
                        ],
                      ),
                    ),
                  ),
                )
            )
          ]
        ]
      );
    }
  }

  void _onCreateEventTap(){
    setState(() {
      _isCreatingEvent = true;
    });
  }

  void _onDismissCreateEvent(){
    setState(() {
      _isCreatingEvent = false;
    });
  }

  //TODO add check if event is being send and block application while sending
  void _applyCreateEvent(MapEventData eventData) async {
    MapEventData dataWithPos = eventData.copyProvidePosition(eventData, _currentMapIconCreateEventPosition);
    setState(() {
      _isSendingEvent = true;
    });
    CosmosResponse response = await sportEventEngine.sportService.addSportEvent(dataWithPos);
    setState(() {
      _isSendingEvent = false;
    });
    if(response.result.statusCode < 200 || response.result.statusCode > 299){
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Could not send MapEventData E: ${response.result.diagnostics}")));
      }
    }
    else{
      setState(() {
        _isCreatingEvent = false;
      });
    }
  }

  LatLng offsetPositionByPixels(LatLng original, double dxPx, double dyPx) {
    final camera = mapController.camera;

    final originalPx = camera.project(original);
    final newPx = Point(originalPx.x + dxPx, originalPx.y + dyPx);

    return camera.unproject(newPx);
  }

  List<Marker> _getMarkers(){
    List<Marker> markers = sportEventEngine.eventRepository.getOSMMarkers();

    if(_isCreatingEvent){

      Marker createEventMarker = Marker(point: _currentMapIconCreateEventPosition, child: MapIconCreateEvent());
      markers.add(createEventMarker);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => recalculateMarkersRects(markers));

    return markers;
  }

  void recalculateMarkersRects(List<Marker> markers){
    for(int i = 0; i < markers.length; i++){
      if(markers[i].child is MapIcon) {
        (markers[i].child as MapIcon).controller.recalculateRects();
      }
    }
  }

  void refreshMarkers(){
    setState(() {});
  }

  void onPanelGeometryChanged(MapMarkerRect mapMarkerRect){
    sportEventEngine.updateRects(mapMarkerRect , mapController.camera.visibleBounds);
  }

  Widget _getMapIconEvent(MapEventData mapEventData){
    MapIcon mapIcon = MapIcon(_getZoomMultiplier , onPanelGeometryChanged , MapIconController() , mapEventData);
    return mapIcon;
  }

  /*
  Widget _getMapIcon(double zoomMultiplier){
    MapIcon mapIcon = MapIcon(_getZoomMultiplier);
    return mapIcon;
  }
   */

  double _getMarkerWidth(){
    return 120 * _getZoomMultiplier();
  }

  double _getMarkerHeight(){
    return 180 * _getZoomMultiplier();
  }

  double _getZoomMultiplier() => (zoomValue / 14.0).clamp(0.85, 1.25);

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