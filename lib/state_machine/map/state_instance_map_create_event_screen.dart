import 'package:flutter/material.dart';
import 'package:sportm8s/events/map_create_event.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/services/server_sport_service.dart';
import 'package:sportm8s/state_machine/map/state_instance_map_create_event_select_point.dart';
import 'package:sportm8s/state_machine/state_instance.dart';

class StateInstanceMapCreateEventScreen extends StateInstance{
  final ServerSportService _serverSportService;
  final void Function(MapEventData) _onApplyCallback;

  StateInstanceMapCreateEventScreen(super.stateMachineResolver , this._serverSportService , this._onApplyCallback);

  @override
  void onEntered(BuildContext context) {
    if(context.mounted) {
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  Scaffold(
                    appBar: AppBar(
                      title: Text("Create Event"),
                      leading: IconButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                            stateMachineResolver.goToState(StateInstanceMapCreateEventSelectPoint, context);
                          },
                          icon: Icon(Icons.arrow_back),
                      ),
                    ),
                    body: SafeArea(
                        child: MapCreateEventPanel(_onDismissClicked , _onApplyClicked , _serverSportService),
                    ),
                  )
          )
      );
    }
  }

  @override
  void onExited(BuildContext context) {

  }

  void _onDismissClicked(){

  }

  void _onApplyClicked(MapEventData mapEventData , BuildContext context){
    _onApplyCallback(mapEventData);

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

}