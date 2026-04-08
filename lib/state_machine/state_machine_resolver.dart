import 'package:flutter/material.dart';
import 'package:sportm8s/state_machine/state_instance.dart';

class StateMachineResolver{
  late StateInstance currentState;

  StateMachineResolver();

  void goToState(Type stateType , BuildContext context){
    var connectionResult = currentState.goToState(stateType , context);
    if(connectionResult.connectionEstablished){
      currentState = connectionResult.stateEntered!;
    }
  }

  void init(BuildContext context){}

  void enterDefaultState(StateInstance defaultState , BuildContext context){
    currentState = defaultState;
    currentState.onEntered(context);
  }

  bool isCurrentStateActive(Type stateType) => currentState.runtimeType == stateType;
}