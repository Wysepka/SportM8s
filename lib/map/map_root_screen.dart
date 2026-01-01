import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/events/map_create_event.dart';
import 'package:sportm8s/map/map_root_drawer.dart';
import 'package:sportm8s/map/map_side_view.dart';

class MapRootScreen extends StatelessWidget{
  const MapRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      return Scaffold(
        appBar: AppBar(),
        drawer: MapRootDrawer(
          onCreateEventCallback: () => Drawer(),
        ),
        body: MapSideView(),
      );
  }

  /*
  void _openCreateEventView(BuildContext buildContext){
    Navigator.of(buildContext).pop();
    showModalBottomSheet(
        context: buildContext,
        builder: (buildContext) => MapCreateEventPanel()
    );
  }


   */
}