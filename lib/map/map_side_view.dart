
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:sportm8s/app_consts.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/logger/logger_config.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/core/models/cosmos_response.dart';
import 'package:sportm8s/core/utility/event_utility.dart';
import 'package:sportm8s/core/utility/random_utility.dart';
import 'package:sportm8s/dto/api_result.dart';
import 'package:sportm8s/events/map_event_widget_container.dart';
import 'package:sportm8s/events/map_join_event.dart';
import 'package:sportm8s/map/engine/sport_event_calculator.dart';
import 'package:sportm8s/map/engine/sport_event_controller.dart';
import 'package:sportm8s/map/engine/sport_event_repository.dart';
import 'package:sportm8s/map/icon/map_icon.dart';
import 'package:sportm8s/map/icon/map_icon_controller.dart';
import 'package:sportm8s/map/icon/map_icon_create_event.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/map/models/map_marker_rect.dart';
import 'package:sportm8s/map/panels/map_view_bottom_panel.dart';
import 'package:sportm8s/map/panels/map_view_bottom_panel_controller.dart';
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
  bool _isJoiningEvent = false;
  double zoomValue = 0;
  LatLng _currentCenteredPosition = LatLng(0, 0);
  LatLng _currentMapIconCreateEventPosition = LatLng(0, 0);
  Point<double> _currentMapPixelsSize = Point(0, 0);
  EventServiceRequestType eventRequestType = EventServiceRequestType.Idle;
  MapEventData? _currentClickedMapEvent;
  MapViewBottomPanel? bottomPanel;

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
                        _currentClickedMapEvent = null;
                        _isJoiningEvent = false;
                        _trySetBottomPanelEventType(MapViewBottomPanelType.CreatingEvent);
                      });
                    }
                    if(event is MapEventTap){
                      _currentClickedMapEvent = null;
                      _isJoiningEvent = false;
                      _trySetBottomPanelEventType(MapViewBottomPanelType.CreatingEvent);
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

          if(_isJoiningEvent)...[
              if(_currentClickedMapEvent != null)...[
                MapJoinEvent(_currentClickedMapEvent! , _applyJoinEvent , _onDismissJoinEvent , sportEventEngine.sportService , _onUserDeletedEvent),
              ]
              else...[
                Center(
                  child: MapEventWidgetContainer(
                    child: Text(
                      "Could not Join Event, _currentClickedMapEvent is null !",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 30
                      ),
                    ),
                  ),
                )
              ]
          ],

          if(_isCreatingEvent)...[
            MapCreateEventPanel(_onDismissCreateEvent , _applyCreateEvent ,sportEventEngine.sportService),
          ],

          if(!_isCreatingEvent && !_isJoiningEvent)...[
            bottomPanel = MapViewBottomPanel(MapViewBottomPanelController() , _onCreateEventTap, _onJoinEventTap),
          ],

          if(eventRequestType != EventServiceRequestType.Idle)...[
            Positioned.fill(
                child: IgnorePointer(
                  ignoring: true,
                  child: Container(
                    color: Colors.white38.withOpacity(0.5),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          Text(EventUtility.getLocalisedEventRequestTypeName(eventRequestType))
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

  void _onUserDeletedEvent(){
    setState(() {
      _isJoiningEvent = false;
      _currentClickedMapEvent = null;
    });
    sportEventEngine.update();
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

  void _onJoinEventTap(){
    setState(() {
      _isJoiningEvent = true;
    });
  }

  void _onDismissJoinEvent(){
    setState(() {
      _isJoiningEvent = false;
    });
  }

  //TODO add check if event is being send and block application while sending
  void _applyCreateEvent(MapEventData eventData) async {
    MapEventData dataWithPos = eventData.copyProvidePosition(eventData, _currentMapIconCreateEventPosition);
    setState(() {
      eventRequestType = EventServiceRequestType.CreatingEvent;
    });
    ApiResult<bool> response = await sportEventEngine.sportService.addSportEvent(dataWithPos);
    setState(() {
      eventRequestType = EventServiceRequestType.Idle;
    });
    if(response.statusCode < 200 || response.statusCode > 299){
      if(context.mounted) {
        if(kDebugMode) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Could not send MapEventData E: ${(response as ErrorResult<bool>).error.errorMessage}")));
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Something went wrong")));
        }
      }
    }
    else{
      setState(() {
        _isCreatingEvent = false;
      });
    }

    sportEventEngine.update();
  }

  void _applyJoinEvent(MapEventData mapEventData) async {
    setState(() {
      eventRequestType = EventServiceRequestType.JoiningEvent;
    });
    ApiResult<bool> result = await sportEventEngine.sportService.joinSportEvent(mapEventData);
    setState(() {
      eventRequestType = EventServiceRequestType.Idle;
    });
    if(!result.success){
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Could not send MapEventData E: ${(result as ErrorResult<bool>).error.errorMessage}")));
      }
    }
    else{
      setState(() {
        _isJoiningEvent = false;
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
    MapIcon mapIcon = MapIcon(_getZoomMultiplier , onPanelGeometryChanged , _onMapIconClicked , MapIconController() , mapEventData);
    return mapIcon;
  }

  double _getMarkerWidth(){
    return 120 * _getZoomMultiplier();
  }

  double _getMarkerHeight(){
    return 180 * _getZoomMultiplier();
  }

  double _getZoomMultiplier() => (zoomValue / 14.0).clamp(0.85, 1.25);

  void _onMapIconClicked(MapEventData mapEventData)
  {
    _currentClickedMapEvent = mapEventData;
    _trySetBottomPanelEventType(MapViewBottomPanelType.JoiningEvent);
  }

  void _trySetBottomPanelEventType(MapViewBottomPanelType type){
    if(bottomPanel != null){
      bottomPanel!.controller.changeBottomPanelType(type);
    }
  }

  bool isMapEventClicked() => _currentClickedMapEvent != null;

  MapEventData get currentClickedMapEvent => _currentClickedMapEvent!;
}

class OSMMarkerData{

  Widget Function(MapEventData mapEventData) mapIconEvent;
  double Function() markerWidth;
  double Function() markerHeight;
  double Function() zoomValue;

  OSMMarkerData(this.mapIconEvent , this.markerWidth , this.markerHeight , this.zoomValue);

}