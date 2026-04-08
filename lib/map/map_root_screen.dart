import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/calendar/calendar_screen.dart';
import 'package:sportm8s/events/map_create_event.dart';
import 'package:sportm8s/map/engine/sport_event_calculator.dart';
import 'package:sportm8s/map/engine/sport_event_controller.dart';
import 'package:sportm8s/map/engine/sport_event_engine.dart';
import 'package:sportm8s/map/engine/sport_event_repository.dart';
import 'package:sportm8s/map/map_root_drawer.dart';
import 'package:sportm8s/map/map_side_view.dart';
import 'package:sportm8s/map/map_side_view_controller.dart';
import 'package:sportm8s/map/panels/map_view_bottom_panel_controller.dart';
import 'package:sportm8s/profile/views/change_display_profile_screen.dart';
import 'package:sportm8s/services/server_service.dart';
import 'package:sportm8s/services/server_sport_service.dart';

import '../core/enums/enums_container.dart';

class MapRootScreen extends StatefulWidget{
  const MapRootScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MapRootScreen();
}

class _MapRootScreen extends State<MapRootScreen>{
  MapBodyType mapBodyType = MapBodyType.Map;
  final MainSportEventRepository mainSportEventRepository = MainSportEventRepository();
  late final SportEventEngine sportEventEngine;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final serverServiceContainer = ProviderScope.containerOf(context , listen: false);
    final serverService = serverServiceContainer.read(serverServiceProvider);

    sportEventEngine = SportEventEngine(SportEventController(), ServerSportService(serverService), mainSportEventRepository ,SportEventCalculator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MapRootDrawer(onMapBodyTypeChanged: onMapBodyTypeChanged,),
      body: getMapBodyWidget(),
    );
  }

  void onMapBodyTypeChanged(MapBodyType mapBodyType){
    setState(() {
      this.mapBodyType = mapBodyType;
    });
  }

  Widget getMapBodyWidget(){
    switch(mapBodyType){
      case MapBodyType.Invalid:
        throw Exception("Could not provide body widget for MapBodyType.Invalid");
      case MapBodyType.Map:
        return MapSideView(sportEventEngine , MapSideViewController());
      case MapBodyType.Calendar:
        return CalendarScreen(sportEventEngine);
      case MapBodyType.Profile:
        return ChangeDisplayProfileScreen();
    }
  }

}