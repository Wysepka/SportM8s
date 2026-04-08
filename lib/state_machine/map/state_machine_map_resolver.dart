import 'package:flutter/cupertino.dart';
import 'package:sportm8s/map/containers/map_callbacks_container.dart';
import 'package:sportm8s/map/engine/sport_event_engine.dart';
import 'package:sportm8s/map/initializers/map_view_initializer.dart';
import 'package:sportm8s/map/map_side_view_controller.dart';
import 'package:sportm8s/state_machine/map/state_instance_map_create_event_screen.dart';
import 'package:sportm8s/state_machine/map/state_instance_map_create_event_select_point.dart';
import 'package:sportm8s/state_machine/map/state_instance_map_idle.dart';
import 'package:sportm8s/state_machine/map/state_instance_map_join_event.dart';
import 'package:sportm8s/state_machine/state_machine_resolver.dart';

class StateMachineMapResolver extends StateMachineResolver{

  final SportEventEngine sportEventEngine;
  final MapCallbacksContainer mapCallbacksContainer;
  final MapSideViewController mapSideViewController;
  final MapViewDataContainer mapInitializationDataResult;

  StateMachineMapResolver(this.sportEventEngine , this.mapCallbacksContainer , this.mapSideViewController , this.mapInitializationDataResult);

  @override
  void init(BuildContext context){
    StateInstanceMapIdle mapIdleState = StateInstanceMapIdle(this , mapInitializationDataResult);
    StateInstanceMapCreateEventSelectPoint selectPointState = StateInstanceMapCreateEventSelectPoint(this , mapSideViewController , mapInitializationDataResult , sportEventEngine);
    StateInstanceMapCreateEventScreen eventScreenState = StateInstanceMapCreateEventScreen(this ,sportEventEngine.sportService , mapCallbacksContainer.onCreateEventCallback);
    StateInstanceMapJoinEvent mapJoinEvent = StateInstanceMapJoinEvent(this , mapCallbacksContainer.onJoinEventCallback , mapCallbacksContainer.getMapJoinWidget , mapCallbacksContainer.getCurrentMapEventData);

    mapIdleState.registerConnection(selectPointState);
    mapIdleState.registerConnection(mapJoinEvent);
    selectPointState.registerConnection(eventScreenState);
    eventScreenState.registerConnection(mapIdleState);

    //reverse
    selectPointState.registerConnection(mapIdleState);
    eventScreenState.registerConnection(selectPointState);
    mapJoinEvent.registerConnection(mapIdleState);

    enterDefaultState(mapIdleState , context);
  }
}