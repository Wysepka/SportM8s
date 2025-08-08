import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/map/map_root_drawer.dart';
import 'package:sportm8s/map/map_side_view.dart';

class MapRootScreen extends StatelessWidget{
  const MapRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        drawer: MapRootDrawer(),
        body: MapSideView(),
      ),
    );
  }

}