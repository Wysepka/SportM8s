
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportm8s/app_consts.dart';

class MapSideView extends StatelessWidget{
  const MapSideView({super.key});

  @override
  Widget build(BuildContext context) {
    if(AppConsts.IS_PRODUCTION){
      return Center(child: Text("Production Ready map is not available !"));
    }
    else {
      // TODO: implement build
      return FlutterMap(
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
      );
    }
  }

List<Marker> _getMarkers_Test(){
    List<Marker> markersList = [];
    
    markersList.add(Marker(
      point: LatLng( 52.337049, 21.117532),
      width: 10,
      height: 10,
      child: _getMarkerChild(),
    ));

    markersList.add(Marker(
      point: LatLng( 52.537049, 21.227532),
      width: 10,
      height: 10,
      child: _getMarkerChild(),
    ));

    markersList.add(Marker(
      point: LatLng( 52.427049, 21.25532),
      width: 10,
      height: 10,
      child: _getMarkerChild(),
    ));

    return markersList;
}

Widget _getMarkerChild(){
    return GestureDetector(
      onTap: () => print("Marker tapped!"),
      child: Column(
        children: [
          const Icon(Icons.location_on, size: 20, color: Colors.red),
          Container(
            padding: const EdgeInsets.all(4),
            color: Colors.white,
            child: const Text("Event A", style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
}
  
}