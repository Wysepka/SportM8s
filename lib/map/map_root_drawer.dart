
import 'package:flutter/material.dart';

class MapRootDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child:ListView(children: [
        ListTile(
          title: Text("Map"),
        ),
        ListTile(
          title: TextButton(onPressed: () {  },
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