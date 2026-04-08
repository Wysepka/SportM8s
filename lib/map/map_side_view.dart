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
import 'package:sportm8s/events/map_join_event.dart';
import 'package:sportm8s/map/containers/map_callbacks_container.dart';
import 'package:sportm8s/map/icon/map_icon.dart';
import 'package:sportm8s/map/icon/map_icon_controller.dart';
import 'package:sportm8s/map/initializers/map_view_initializer.dart';
import 'package:sportm8s/map/map_side_view_controller.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/map/models/map_marker_rect.dart';
import 'package:sportm8s/map/panels/map_location_pin_widget.dart';
import 'package:sportm8s/map/panels/map_view_bottom_panel.dart';
import 'package:sportm8s/map/panels/map_view_bottom_panel_controller.dart';
import 'package:sportm8s/state_machine/map/state_instance_map_create_event_select_point.dart';
import 'package:sportm8s/state_machine/map/state_instance_map_idle.dart';
import 'package:sportm8s/state_machine/map/state_instance_map_join_event.dart';
import 'package:sportm8s/state_machine/map/state_machine_map_resolver.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'engine/sport_event_engine.dart';
import 'helpers/map_animations.dart';


class MapSideView extends StatefulWidget{
  final SportEventEngine sportEventEngine;
  final MapSideViewController sideViewController;

  const MapSideView(this.sportEventEngine, this.sideViewController, {super.key});

  @override
  State<StatefulWidget> createState() => _MapSideView();
}

class _MapSideView extends State<MapSideView> with TickerProviderStateMixin{
  LoggerService _loggerService = LoggerService();
  final MapController _mapController = new MapController();
  double _zoomValue = 0;
  EventServiceRequestType _eventRequestType = EventServiceRequestType.Idle;
  MapEventData? _currentClickedMapEvent;
  MapViewBottomPanel? bottomPanel;

  late Future<MapViewDataContainer> _initializationFuture;

  late final MapAnimations _mapAnimations;
  late final StateMachineMapResolver _stateMachineResolver;

  @override void initState() {
    super.initState();

    OSMMarkerDataCallbacks markerData = OSMMarkerDataCallbacks(_getMapIconEvent, _getMarkerWidth, _getMarkerHeight, _getZoomMultiplier);
    widget.sportEventEngine.eventController.addListener(onSportEventsChanged);
    widget.sportEventEngine.initialize(markerData);
    widget.sportEventEngine.eventRepository.rebuildMarkers(markerData.mapIconEvent);
    widget.sportEventEngine.eventController.addListener(refreshMarkers);

    final mapViewInitialize = MapViewInitializer(_loggerService);

    _initializationFuture = mapViewInitialize.initializeMapData();

    _mapAnimations = MapAnimations(mapController: _mapController, vsync: this ,mapViewDataContainer:  widget.sideViewController.mapViewDataContainer);

    final mapCallbacksContainer = MapCallbacksContainer(
      onCreateEventCallback: _applyCreateEvent,
      onJoinEventCallback: _applyJoinEvent,
      getMapJoinWidget: _getMapJoinEventScreen,
      getCurrentMapEventData: getCurrentClickedMapEvent
    );

    _stateMachineResolver = StateMachineMapResolver(widget.sportEventEngine , mapCallbacksContainer , widget.sideViewController , widget.sideViewController.mapViewDataContainer);
    _stateMachineResolver.init(context);

    widget.sideViewController.mapViewDataContainer.addListener(_updateMapPosition);
  }

  @override
  void didUpdateWidget(covariant MapSideView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(oldWidget.sideViewController.mapViewDataContainer != widget.sideViewController.mapViewDataContainer){
      oldWidget.sideViewController.mapViewDataContainer.removeListener(_updateMapPosition);
      widget.sideViewController.mapViewDataContainer.addListener(_updateMapPosition);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _mapAnimations.dispose();

    widget.sportEventEngine.dispose();
    widget.sportEventEngine.eventController.removeListener(onSportEventsChanged);
    widget.sportEventEngine.eventController.removeListener(refreshMarkers);

    widget.sideViewController.mapViewDataContainer.removeListener(_updateMapPosition);
  }

  void onSportEventsChanged(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final mapInitializationDataResult = widget.sideViewController.mapViewDataContainer;
    // TODO: implement build
    return SafeArea(
      child: (mapInitializationDataResult.locationIntialized && mapInitializationDataResult.styleInitialized) ?
        getMapWidget(mapInitializationDataResult.position , mapInitializationDataResult.style!) :
        futureInitializeMapData()
    );
  }

  Widget futureInitializeMapData(){
    final l10n = AppLocalizations.of(context);

    return FutureBuilder<MapViewDataContainer>(
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

        final data = snapshot.data!;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if(mounted) {
            setState(() {
              widget.sideViewController.mapViewDataContainer.locationIntialized = data.locationIntialized;
              widget.sideViewController.mapViewDataContainer.styleInitialized = data.styleInitialized;
              widget.sideViewController.mapViewDataContainer.position = data.position;
              widget.sideViewController.mapViewDataContainer.style = data.style;
            });
          }
        });

        return const SizedBox(); // or your actual Map widget
      },
    );

  }

  void _updateMapPosition(){
    MapViewDataContainer mapViewDataContainer = widget.sideViewController.mapViewDataContainer;
    _mapController.move(mapViewDataContainer.position, mapViewDataContainer.currentZoom);
    _mapController.rotate(widget.sideViewController.mapViewDataContainer.rotation);
  }

  Widget getMapWidget(LatLng initialPosition , Style mapStyle) {
    final l10n = AppLocalizations.of(context);
      return Stack(
          children: [
            FlutterMap(
                mapController: _mapController,
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
                        _zoomValue = event.camera.zoom;
                        widget.sideViewController.mapViewDataContainer.currentZoom = event.camera.zoom;
                        widget.sideViewController.mapViewDataContainer.rotation = _mapController.camera.rotation;
                        widget.sideViewController.mapViewDataContainer.setMapPosition(_mapController.camera.center);
                        widget.sportEventEngine.updateRectsNoAddition(_mapController
                            .camera.visibleBounds);
                        _currentClickedMapEvent = null;
                        _trySetBottomPanelEventType(MapViewBottomPanelType
                            .CreatingEvent);
                      });
                    }
                    if (event is MapEventTap) {
                      _currentClickedMapEvent = null;
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
                  SafeArea(child: MarkerLayer(markers: _getMarkers()))
                ]
            ),

            bottomPanel = MapViewBottomPanel(MapViewBottomPanelController(), _onCreateEventTap),

            if(_eventRequestType != EventServiceRequestType.Idle)...[
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
                                    _eventRequestType))
                          ],
                        ),
                      ),
                    ),
                  )
              )
            ],

            MapLocationPinWidget(_loggerService, _mapAnimations , widget.sideViewController.mapViewDataContainer),
          ]
      );
  }


  Widget _getMapJoinEventScreen(MapEventData mapEventData){
    return MapJoinEvent(
      mapEventData,
      _applyJoinEvent,
      widget.sportEventEngine.sportService,
      _onUserDeletedEvent,
      _onUserButtonRequestSend,
      widget.sportEventEngine.eventRepository,
    );
  }

  Future<void> _onUserButtonRequestSend(UserEventRequestType requestType) async {
    await widget.sportEventEngine.update(force: true);
  }

  void _onUserDeletedEvent(){
    _stateMachineResolver.goToState(StateInstanceMapIdle, context);
    Navigator.of(context).pop();
    widget.sportEventEngine.update();
  }

  void _onCreateEventTap(){

    setState(() {
      if(context.mounted) {
        _stateMachineResolver.goToState(StateInstanceMapCreateEventSelectPoint , context);
      }
    });
  }

  //TODO add check if event is being send and block application while sending
  void _applyCreateEvent(MapEventData eventData) async {
    MapEventData dataWithPos = eventData.copyProvidePosition(eventData, widget.sideViewController.mapViewDataContainer.position);
    setState(() {
      if(context.mounted) {
        _eventRequestType = EventServiceRequestType.CreatingEvent;
      }
    });
    ApiResult<bool> response = await widget.sportEventEngine.sportService.addSportEvent(dataWithPos);
    setState(() {
      if(context.mounted) {
        _eventRequestType = EventServiceRequestType.Idle;
      }
    });
    if(response.statusCode < 200 || response.statusCode > 299){
      if(mounted) {
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
          _stateMachineResolver.goToState(StateInstanceMapIdle , context);
        }
      });
    }

    if(context.mounted) {
      _stateMachineResolver.goToState(StateInstanceMapIdle , context);
    }

    widget.sportEventEngine.update();
  }

  void _applyJoinEvent(MapEventData mapEventData) async {
    setState(() {
      if(context.mounted) {
        _eventRequestType = EventServiceRequestType.JoiningEvent;
      }
    });
    ApiResult<bool> result = await widget.sportEventEngine.sportService.joinSportEvent(mapEventData);
    setState(() {
      if(context.mounted) {
        _eventRequestType = EventServiceRequestType.Idle;
      }
    });
    if(!result.success){
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Could not send MapEventData E: ${(result as ErrorResult<bool>).error.errorMessage}")));
      }
    }
    else{
      setState(() {
        if(context.mounted) {
          _stateMachineResolver.goToState(StateInstanceMapIdle , context);
        }
      });
    }
  }

  List<Marker> _getMarkers(){
    List<Marker> markers = widget.sportEventEngine.eventRepository.getOSMMarkers();

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
    widget.sportEventEngine.updateRects(mapMarkerRect , _mapController.camera.visibleBounds);
  }

  Widget _getMapIconEvent(MapEventData mapEventData){
    MapIcon mapIcon = MapIcon(_getZoomMultiplier , onPanelGeometryChanged , _onMapIconClicked , MapIconController() , mapEventData , widget.sideViewController);
    return mapIcon;
  }

  double _getMarkerWidth(){
    return 120 * _getZoomMultiplier();
  }

  double _getMarkerHeight(){
    return 180 * _getZoomMultiplier();
  }

  double _getZoomMultiplier() => (_zoomValue / 14.0).clamp(0.85, 1.25);

  void _onMapIconClicked(MapEventData mapEventData)
  {
    _currentClickedMapEvent = mapEventData;
    
    _stateMachineResolver.goToState(StateInstanceMapJoinEvent , context);
  }

  void _trySetBottomPanelEventType(MapViewBottomPanelType type){
    if(bottomPanel != null){
      bottomPanel!.controller.changeBottomPanelType(type);
    }
  }

  bool isMapEventClicked() => _currentClickedMapEvent != null;

  MapEventData getCurrentClickedMapEvent() => _currentClickedMapEvent!;
}

class OSMMarkerDataCallbacks{

  Widget Function(MapEventData mapEventData) mapIconEvent;
  double Function() markerWidth;
  double Function() markerHeight;
  double Function() zoomValue;

  OSMMarkerDataCallbacks(this.mapIconEvent , this.markerWidth , this.markerHeight , this.zoomValue);

}