import 'package:flutter/material.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/events/map_select_event_position.dart';
import 'package:sportm8s/graphics/sportm8s_themes.dart';
import 'package:sportm8s/map/engine/sport_event_engine.dart';
import 'package:sportm8s/map/initializers/map_view_initializer.dart';
import 'package:sportm8s/map/map_side_view_controller.dart';
import 'package:sportm8s/state_machine/map/state_instance_map_create_event_screen.dart';
import 'package:sportm8s/state_machine/map/state_instance_map_idle.dart';
import 'package:sportm8s/state_machine/state_instance.dart';

class StateInstanceMapCreateEventSelectPoint extends StateInstance{

  final MapSideViewController mapSideViewController;
  final MapViewDataContainer mapInitializationDataResult;
  final SportEventEngine sportEventEngine;

  bool isViewOpened = false;

  StateInstanceMapCreateEventSelectPoint(super.stateMachineResolver , this.mapSideViewController , this.mapInitializationDataResult , this.sportEventEngine);

  @override
  void onEntered(BuildContext context) {
    mapSideViewController.setMapScreenType(MapScreenType.MapSelectEventPosition);
    if(isViewOpened){
      return;
    }
    if(context.mounted) {
      isViewOpened = true;
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  Scaffold(
                    appBar: AppBar(
                      title: Text("Select Event Location"),
                      leading: IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          stateMachineResolver.goToState(StateInstanceMapIdle, context);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                    ),
                    body: SafeArea(
                      child: MapSelectEventPosition(mapInitializationDataResult , sportEventEngine , goToNextState),
                    ),
                  )
          )
      ).then((_) {
        isViewOpened = false;
      });
    }
  }

  @override
  void onExited(BuildContext context) {
    mapSideViewController.setMapScreenType(MapScreenType.MapSideView);
  }

  final StateInstanceWidgetType _stateInstanceWidgetType = StateInstanceWidgetType.None;

  @override
  StateInstanceWidgetType get stateInstanceWidgetType => _stateInstanceWidgetType;


  void goToNextState(BuildContext context){
    stateMachineResolver.goToState(StateInstanceMapCreateEventScreen , context);
  }

}