import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/events/map_join_event.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/state_machine/map/state_instance_map_idle.dart';
import 'package:sportm8s/state_machine/state_instance.dart';

class StateInstanceMapJoinEvent extends StateInstance{
  final void Function(MapEventData mapEventData) onJoinEventCallback;
  final Widget Function(MapEventData mapEventData) _getMapCreateEventScreen;
  final MapEventData Function() _getCurrentMapEventData;

  StateInstanceMapJoinEvent(super.stateMachineResolver , this.onJoinEventCallback , this._getMapCreateEventScreen , this._getCurrentMapEventData);

  @override
  void onEntered(BuildContext context) {
    if(context.mounted) {
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  Scaffold(
                    appBar: AppBar(
                      title: Text("Join Event"),
                      leading: IconButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                            stateMachineResolver.goToState(StateInstanceMapIdle, context);
                          },
                          icon: Icon(Icons.arrow_back)
                      ),
                    ),
                    body: SafeArea(
                        child: _getMapCreateEventScreen(_getCurrentMapEventData()),
                    ),
                  )
          )
      );
    }
  }

  @override
  void onExited(BuildContext context) {

  }

}