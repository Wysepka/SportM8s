
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/core/utility/event_utility.dart';
import 'package:sportm8s/core/utility/location_utility.dart';
import 'package:sportm8s/dto/api_result.dart';
import 'package:sportm8s/events/map_event_widget_container.dart';
import 'package:sportm8s/events/map_join_event.dart';
import 'package:sportm8s/graphics/sportm8s_themes.dart';
import 'package:sportm8s/map/icon/map_icon.dart';
import 'package:sportm8s/map/icon/map_icon_controller.dart';
import 'package:sportm8s/map/icon/map_icon_create_event.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/map/models/map_marker_rect.dart';
import 'package:sportm8s/map/panels/map_view_bottom_panel.dart';
import 'package:sportm8s/map/panels/map_view_bottom_panel_controller.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../events/map_create_event.dart';
import 'engine/sport_event_engine.dart';
import 'helpers/map_animations.dart';


class MapSideView extends StatefulWidget{
  final SportEventEngine sportEventEngine;

  const MapSideView(this.sportEventEngine, {super.key});

  @override
  State<StatefulWidget> createState() => _MapSideView();
}

class _MapSideView extends State<MapSideView> with TickerProviderStateMixin{
  //_MapSideView({super.key});
  LoggerService loggerService = LoggerService();
  final MapController mapController = new MapController();
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

  bool locationInitialized = false;
  bool styleInitialized = false;
  late Style darkStyle;
  LatLng initialLocation = LatLng(52, 21);

  late Future<void> _initializationFuture;

  late final MapAnimations _mapAnimations;

  @override void initState() {
    // TODO: implement initState
    super.initState();

    OSMMarkerData markerData = OSMMarkerData(_getMapIconEvent, _getMarkerWidth, _getMarkerHeight, _getZoomMultiplier);
    widget.sportEventEngine.eventController.addListener(onSportEventsChanged);
    widget.sportEventEngine.initialize(markerData);
    widget.sportEventEngine.eventRepository.rebuildMarkers(markerData.mapIconEvent);
    widget.sportEventEngine.eventController.addListener(refreshMarkers);

    _initializationFuture = initializeMapData();

    _mapAnimations = MapAnimations(mapController: mapController, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _mapAnimations.dispose();

    widget.sportEventEngine.dispose();
    widget.sportEventEngine.eventController.removeListener(onSportEventsChanged);
    widget.sportEventEngine.eventController.removeListener(refreshMarkers);
  }

  void onSportEventsChanged(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context);

    // TODO: implement build
    return SafeArea(
      child: (locationInitialized && styleInitialized) ?
        getMapWidget(initialLocation , darkStyle) :
        futureInitializeMapData()
    );
  }

  Widget futureInitializeMapData(){
    final l10n = AppLocalizations.of(context);

    return FutureBuilder<void>(
      future: _initializationFuture,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n?.map_MapIsLoading ?? "Initializing Map..."),
                const SizedBox(width: 10),
                const CircularProgressIndicator(),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(l10n?.map_LoadingDataError ??"Error while initializing map"),
          );
        }

        if(!snapshot.hasData){
          return Center(
            child: Text(l10n?.map_LoadedDataEmpty ?? "Loaded map data is empty"),
          );
        }

        return const SizedBox(); // or your actual Map widget
      },
    );

  }

  Future<void> initializeMapData() async {
    try {
      final location = await LocationUtility.loadCurrentUserLocation(loggerService);
      initialLocation = location;
      loggerService.info("Current user location initialized properly");

      locationInitialized = true;

      final style = await loadMapStyle();
      // store style somewhere if needed
      darkStyle = style;
      loggerService.info("Map style loaded properly");

      styleInitialized = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(mounted) {
          setState(() {

          });
        }
      });

    } catch (e) {
      loggerService.error("Initialization error: $e");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(mounted) {
          setState(() {

          });
        }
      });

      rethrow;
    }
  }

  Widget getMapWidget(LatLng initialPosition , Style mapStyle) {
    final l10n = AppLocalizations.of(context);
      return Stack(
          children: [
            Positioned.fill(
              child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    //TODO add LatLng info getting from phone localization
                    initialCenter: initialPosition,
                    initialZoom: 13.0,
                    minZoom: 7,
                    maxZoom: 16,
                    cameraConstraint: CameraConstraint.containCenter(bounds: LocationUtility.polandLatLngBounds),
                    onMapEvent: (event) {
                      if (event is MapEventDoubleTapZoomEnd ||
                          event is MapEventDoubleTapZoomStart
                          || event is MapEventMoveStart ||
                          event is MapEventMoveEnd) {
                        setState(() {
                          zoomValue = event.camera.zoom;
                          widget.sportEventEngine.updateRectsNoAddition(mapController
                              .camera.visibleBounds);
                          _currentCenteredPosition = event.camera.center;
                          _currentMapPixelsSize = event.camera.size;
                          double offsetByPxInHeight = _currentMapPixelsSize
                              .y * -0.25;
                          _currentMapIconCreateEventPosition =
                              offsetPositionByPixels(
                                  _currentCenteredPosition, 0,
                                  offsetByPxInHeight);
                          _currentClickedMapEvent = null;
                          _isJoiningEvent = false;
                          _trySetBottomPanelEventType(MapViewBottomPanelType
                              .CreatingEvent);
                        });
                      }
                      if (event is MapEventTap) {
                        _currentClickedMapEvent = null;
                        _isJoiningEvent = false;
                        _trySetBottomPanelEventType(
                            MapViewBottomPanelType.CreatingEvent);
                      }
                    },
                  ),
                  children: [
                    VectorTileLayer(
                      theme: mapStyle.theme,
                      tileProviders: mapStyle.providers,
                    ),
                    //MarkerLayer(markers: RandomUtility.getMarkers_Test(_getMarkerWidth, _getMarkerHeight, _getMapIcon , _getZoomMultiplier))
                    SafeArea(child: MarkerLayer(markers: _getMarkers()))
                  ]
              ),
            ),

            if(_isJoiningEvent)...[
              if(_currentClickedMapEvent != null)...[
                //_getMapCreateEventScreen(_currentClickedMapEvent!),
              ]
              else
                ...[
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
              MapCreateEventPanel(_onDismissCreateEvent, _applyCreateEvent,
                  widget.sportEventEngine.sportService),
            ],

            if(!_isCreatingEvent && !_isJoiningEvent)...[
              bottomPanel = MapViewBottomPanel(
                  MapViewBottomPanelController(), _onCreateEventTap),
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
                            Text(
                                EventUtility.getLocalisedEventRequestTypeName(
                                    eventRequestType))
                          ],
                        ),
                      ),
                    ),
                  )
              )
            ],

            Positioned(
              right: 15,
              top: 15,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: SportM8sColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: IconButton(
                  icon: Icon(Icons.location_on , color: SportM8sColors.accent,),
                  iconSize: 24,
                  onPressed: lerpMapToCurrentUserLocation),
              )
            ),
          ]
      );
  }

  Widget _getMapCreateEventScreen(MapEventData mapEventData){
    return MapJoinEvent(
      mapEventData,
      _applyJoinEvent,
      _onDismissJoinEvent,
      widget.sportEventEngine.sportService,
      _onUserDeletedEvent,
      _onUserButtonRequestSend,
      widget.sportEventEngine.eventRepository,
      MapJoinEventScreenType.Map,
    );
  }

  void lerpMapToCurrentUserLocation() async{
    LatLng currentPos = await LocationUtility.loadCurrentUserLocation(loggerService);
    _mapAnimations.animateTo(destination: currentPos, zoom: 16);
  }

  Future<Style> loadMapStyle() => StyleReader(
    uri: 'https://maps.sportm8s.app/styles/sportm8s-dark/style.json',
    // apiKey: '', // not needed for your own server
  ).read();

  Future<void> _onUserButtonRequestSend(UserEventRequestType requestType) async {
    await widget.sportEventEngine.update(force: true);

    setState(() {
      if(context.mounted) {
        var updateClickedMapEvent = widget.sportEventEngine.eventRepository
            .getMapSportEventDataBasedOnID(_currentClickedMapEvent!.eventID);
        if (updateClickedMapEvent.success) {
          _currentClickedMapEvent = updateClickedMapEvent.data!.eventData;
        }
      }
    });
  }

  void _onUserDeletedEvent(){
    setState(() {
      if(context.mounted) {
        _isJoiningEvent = false;
        _currentClickedMapEvent = null;
      }
    });
    widget.sportEventEngine.update();
  }

  void _onCreateEventTap(){
    setState(() {
      if(context.mounted) {
        _isCreatingEvent = true;
      }
    });
  }

  void _onDismissCreateEvent(){
    setState(() {
      if(context.mounted) {
        _isCreatingEvent = false;
      }
    });
  }

  void _onJoinEventTap(){
    setState(() {
      if(context.mounted) {
        _isJoiningEvent = true;
      }
    });
  }

  void _onDismissJoinEvent(){
    setState(() {
      if(context.mounted) {
        _isJoiningEvent = false;
      }
    });
  }

  //TODO add check if event is being send and block application while sending
  void _applyCreateEvent(MapEventData eventData) async {
    MapEventData dataWithPos = eventData.copyProvidePosition(eventData, _currentMapIconCreateEventPosition);
    setState(() {
      if(context.mounted) {
        eventRequestType = EventServiceRequestType.CreatingEvent;
      }
    });
    ApiResult<bool> response = await widget.sportEventEngine.sportService.addSportEvent(dataWithPos);
    setState(() {
      if(context.mounted) {
        eventRequestType = EventServiceRequestType.Idle;
      }
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
        if(context.mounted) {
          _isCreatingEvent = false;
        }
      });
    }

    widget.sportEventEngine.update();
  }

  void _applyJoinEvent(MapEventData mapEventData) async {
    setState(() {
      if(context.mounted) {
        eventRequestType = EventServiceRequestType.JoiningEvent;
      }
    });
    ApiResult<bool> result = await widget.sportEventEngine.sportService.joinSportEvent(mapEventData);
    setState(() {
      if(context.mounted) {
        eventRequestType = EventServiceRequestType.Idle;
      }
    });
    if(!result.success){
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Could not send MapEventData E: ${(result as ErrorResult<bool>).error.errorMessage}")));
      }
    }
    else{
      setState(() {
        if(context.mounted) {
          _isJoiningEvent = false;
        }
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
    List<Marker> markers = widget.sportEventEngine.eventRepository.getOSMMarkers();

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
    if(context.mounted) {
      setState(() {});
    }
  }

  void onPanelGeometryChanged(MapMarkerRect mapMarkerRect){
    widget.sportEventEngine.updateRects(mapMarkerRect , mapController.camera.visibleBounds);
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
    if(mounted) {
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  Scaffold(
                    appBar: AppBar(
                        title: Text("Join Event")
                    ),
                    body: SafeArea(
                        child: _getMapCreateEventScreen(mapEventData)
                    ),
                  )
          )
      );
    }
    //_currentClickedMapEvent = mapEventData;
    //_trySetBottomPanelEventType(MapViewBottomPanelType.JoiningEvent);
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