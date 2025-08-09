
import 'package:flutter/material.dart';
import 'package:sportm8s/events/map_create_event.dart';

class MapRootDrawer extends StatelessWidget{
  final VoidCallback onCreateEventCallback;
  const MapRootDrawer({super.key , required this.onCreateEventCallback});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child:ListView(children: [
        ListTile(
          title: Text("Map"),
        ),
        ListTile(
          title: TextButton(onPressed: () { onCreateEventCallback(); },
          child: Text("Create Event")),
        ),
        ListTile(
          title: Text("Profile"),
        ),
        ListTile(
          title: Text("Events"),
        )
      ],),
    );
  }
}