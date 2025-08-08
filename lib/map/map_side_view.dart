
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:sportm8s/app_consts.dart';
import 'package:sportm8s/core/logger/logger_config.dart';
import 'package:sportm8s/core/utility/random_utility.dart';

class MapSideView extends StatelessWidget{
  const MapSideView({super.key});

  @override
  Widget build(BuildContext context) {
    if(AppConsts.IS_PRODUCTION){
      return Center(child: Text("Production Ready map is not available !"));
    }
    else {
      // TODO: implement build
      return GestureDetector(
        child: FlutterMap(
            options: MapOptions(
              //TODO add LatLng info getting from phone localization
              initialCenter: LatLng(52.237049, 21.017532),
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(markers: _getMarkers_Test())
          ]
        ),
      );
    }
  }

List<Marker> _getMarkers_Test(){
    List<Marker> markersList = [];
    
    markersList.add(Marker(
      point: LatLng( 52.337049, 21.117532),
      width: 120,
      height: 180,
      child: _getMarkerChild(),
    ));

    markersList.add(Marker(
      point: LatLng( 52.537049, 21.227532),
      width: 120,
      height: 180,
      child: _getMarkerChild(),
    ));

    markersList.add(Marker(
      point: LatLng( 52.427049, 21.25532),
      width: 120,
      height: 180,
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
          const Icon(Icons.location_on, size: 40, color: Colors.red),
           ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: BoxConstraints(minWidth:  10 , maxWidth:  120 ,minHeight:  10 ,maxHeight:  140),
                child: Text(randomString, style: TextStyle(fontSize: 20) , textAlign: TextAlign.center,),
                decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.circular(25) , border: Border.all(color: Colors.cyan ,width:  10)),
          )),
        ],
      ),
    );
}

}