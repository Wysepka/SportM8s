import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportm8s/core/logger/logger_service.dart';
import 'package:sportm8s/core/utility/location_utility.dart';
import 'package:sportm8s/graphics/sportm8s_themes.dart';
import 'package:sportm8s/map/helpers/map_animations.dart';
import 'package:sportm8s/map/initializers/map_view_initializer.dart';

class MapLocationPinWidget extends StatelessWidget{
  final LoggerService loggerService;
  final MapAnimations mapAnimations;
  final MapViewDataContainer mapViewDataContainer;

  const MapLocationPinWidget(this.loggerService, this.mapAnimations,this.mapViewDataContainer, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
    );
  }

  void lerpMapToCurrentUserLocation() async{
    LatLng currentPos = await LocationUtility.loadCurrentUserLocation(loggerService);
    mapAnimations.animateTo(destination: currentPos, zoom: 16);
  }
}