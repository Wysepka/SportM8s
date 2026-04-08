import 'package:flutter/material.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/state_machine/state_machine_resolver.dart';

abstract class StateInstance{
  final List<StateInstance> _connections = [];
  final StateMachineResolver stateMachineResolver;

  StateInstance(this.stateMachineResolver);

  void onEntered(BuildContext context);
  void onExited(BuildContext context);

  void registerConnection(StateInstance stateInstance){
    _connections.add(stateInstance);
  }

  StateInstance? _tryGetStateInstance(Type stateType){
    if(_connections.any((x) => x.runtimeType == stateType)) {
      return _connections.where((x) => x.runtimeType == stateType).first;
    }
    else{
      return null;
    }
  }

  StateConnectionResultValue goToState(Type stateType , BuildContext context){
    StateInstance? stateInstance = _tryGetStateInstance(stateType);
    if(stateInstance != null) {
      onExited(context);
      stateInstance.onEntered(context);
      return StateConnectionResultValue(true, stateInstance);
    }
    else{
      return StateConnectionResultValue(false, null);
    }
  }

  Widget getStateInstanceWidget(BuildContext context){
    return Center(
      child: Text("Error"),
    );
  }

  List<Widget> getStateInstanceWidgets(BuildContext context){
    return [Center(child: Text("SomeData"),)];
  }

  StateInstanceWidgetType stateInstanceWidgetType = StateInstanceWidgetType.None;
}

class StateConnectionResultValue{
  final bool connectionEstablished;
  final StateInstance? stateEntered;

  StateConnectionResultValue(this.connectionEstablished , this.stateEntered);
}