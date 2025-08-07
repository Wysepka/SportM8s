
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportm8s/app_consts.dart';
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
      width: 120,
      height: 120,
      child: _getMarkerChild(),
    ));

    markersList.add(Marker(
      point: LatLng( 52.537049, 21.227532),
      width: 120,
      height: 120,
      child: _getMarkerChild(),
    ));

    markersList.add(Marker(
      point: LatLng( 52.427049, 21.25532),
      width: 120,
      height: 120,
      child: _getMarkerChild(),
    ));

    return markersList;
}

Widget _getMarkerChild(){
    String randomString = RandomUtility.randomString(10, 30);
    return GestureDetector(
      onTap: () => print("Marker tapped!"),
      child:
      Column(
        children: [
          //Expanded(
          //    flex: 1,
          /*  child: */ const Icon(Icons.location_on, size: 40, color: Colors.red),
          //),
          //Expanded(
          //  flex: 3,
          /*  child: */ Container(
              padding: const EdgeInsets.all(4),
              color: Colors.white,
              constraints: BoxConstraints(minWidth:  10 , maxWidth:  120 ,minHeight:  10 ,maxHeight:  120),
              child: Text(randomString, style: TextStyle(fontSize: 20) , textAlign: TextAlign.center,),
            ),
          //)
        ],
      ),
    );
}

}