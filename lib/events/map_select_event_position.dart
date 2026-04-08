import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/core/utility/location_utility.dart';
import 'package:sportm8s/graphics/sportm8s_themes.dart';
import 'package:sportm8s/map/engine/sport_event_engine.dart';
import 'package:sportm8s/map/helpers/map_animations.dart';
import 'package:sportm8s/map/initializers/map_view_initializer.dart';
import 'package:sportm8s/map/panels/map_location_pin_widget.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

class MapSelectEventPosition extends StatefulWidget{

  final MapViewDataContainer mapViewDataContainer;
  final SportEventEngine sportEventEngine;
  final void Function(BuildContext) onConfirmedLocationCallback;

  MapSelectEventPosition(this.mapViewDataContainer, this.sportEventEngine , this.onConfirmedLocationCallback);

  @override
  State<StatefulWidget> createState() => _MapSelectEventPosition();

}

class _MapSelectEventPosition extends State<MapSelectEventPosition> with TickerProviderStateMixin{

  final MapController mapController = MapController();
  late final MapAnimations mapAnimations;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mapAnimations = MapAnimations(mapController: mapController, vsync: this , mapViewDataContainer: widget.mapViewDataContainer);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            //TODO add LatLng info getting from phone localization
            initialCenter: widget.mapViewDataContainer.position,
            initialZoom: widget.mapViewDataContainer.currentZoom,
            initialRotation: widget.mapViewDataContainer.rotation,
            minZoom: 7,
            maxZoom: 16,
            cameraConstraint: CameraConstraint.containCenter(bounds: LocationUtility.polandLatLngBounds),
            onMapEvent: (event){
              if (event is MapEventDoubleTapZoomEnd ||
                  event is MapEventDoubleTapZoomStart
                  || event is MapEventMoveStart ||
                  event is MapEventMoveEnd) {
                setState(() {
                  widget.mapViewDataContainer.currentZoom = event.camera.zoom;
                  widget.mapViewDataContainer.rotation = mapController.camera.rotation;
                  widget.mapViewDataContainer.setMapPosition(mapController.camera.center);
                  widget.sportEventEngine.updateRectsNoAddition(mapController
                      .camera.visibleBounds);
                });
              }
            }
          ),
          children: [
            VectorTileLayer(
              theme: widget.mapViewDataContainer.style!.theme,
              tileProviders: widget.mapViewDataContainer.style!.providers,
            ),
            //MarkerLayer(markers: RandomUtility.getMarkers_Test(_getMarkerWidth, _getMarkerHeight, _getMapIcon , _getZoomMultiplier))
            SafeArea(child: MarkerLayer(markers: _getMarkers()))
          ]
        ),
        Positioned(
            right: 0,
            bottom: 0,
            left: 0,
            child: Container(
              height: 10,
              color: Colors.red,
            )
        ),
        Positioned(
            bottom: 0,
            left: 0,
            top: 0,
            child: Container(
              width: 10,
              color: Colors.red,
            )
        ),
        Positioned(
            right: 0,
            left: 0,
            top: 0,
            child: Container(
              height: 10,
              color: Colors.red,
            )
        ),
        Positioned(
            bottom: 0,
            right: 0,
            top: 0,
            child: Container(
              width: 10,
              color: Colors.red,
            )
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Icon(Icons.location_on , size: 26, color: SportM8sColors.accent,),
        ),
        Positioned(
            left: 20,
            top: 20,
            right: 65,
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: SportM8sColors.info,
                  borderRadius: BorderRadius.all(Radius.circular(12))
              ),
              child: Text(
                "Select Location",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: ElevatedButton.icon(
            onPressed: () => onConfirmedLocationClicked(context),
            label: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle),
                Text(
                  "Confirm location",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
        MapLocationPinWidget(LoggerService(),mapAnimations , widget.mapViewDataContainer),
      ]
    );
  }

  List<Marker> _getMarkers(){
    List<Marker> markers = widget.sportEventEngine.eventRepository.getOSMMarkers();

    return markers;
  }

  void onConfirmedLocationClicked(BuildContext context){
    widget.onConfirmedLocationCallback(context);
  }

}