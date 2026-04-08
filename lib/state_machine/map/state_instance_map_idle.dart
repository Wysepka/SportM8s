import 'package:flutter/cupertino.dart';
import 'package:sportm8s/map/initializers/map_view_initializer.dart';
import 'package:sportm8s/state_machine/state_instance.dart';

class StateInstanceMapIdle extends StateInstance{
  final MapViewDataContainer mapInitializationDataResult;

  StateInstanceMapIdle(super.stateMachineResolver , this.mapInitializationDataResult);


  @override
  void onEntered(BuildContext context) {

  }

  @override
  void onExited(BuildContext context) {

  }

}