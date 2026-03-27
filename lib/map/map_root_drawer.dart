
import 'package:flutter/material.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/events/map_create_event.dart';

class MapRootDrawer extends StatefulWidget{
  final Function(MapBodyType) onMapBodyTypeChanged;

  const MapRootDrawer({super.key, required this.onMapBodyTypeChanged});

  @override
  State<StatefulWidget> createState() => _MapRootDrawer();
}

class _MapRootDrawer extends State<MapRootDrawer>{
  MapBodyType mapBodyType = MapBodyType.Map;
  //const _MapRootDrawer({required this.onCreateEventCallback});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child:ListView(children: [
        ListTile(
          title: TextButton(onPressed: onMapButtonClicked,
            child: Text("Map"),),
        ),
        ListTile(
          title: TextButton(onPressed: onCalendarButtonClicked,
            child: Text("Calendar")),
        ),
        ListTile(
          title: TextButton(onPressed: onProfileButtonClicked,
            child: Text("Profile"),
          ),
        ),
      ],),
    );
  }

  void onMapButtonClicked(){
    mapBodyType = MapBodyType.Map;
    widget.onMapBodyTypeChanged(mapBodyType);
  }

  void onCalendarButtonClicked(){
    mapBodyType = MapBodyType.Calendar;
    widget.onMapBodyTypeChanged(mapBodyType);
  }

  void onProfileButtonClicked(){
    mapBodyType = MapBodyType.Profile;
    widget.onMapBodyTypeChanged(mapBodyType);
  }
}