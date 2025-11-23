

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../map/models/map_event_data.dart';

class MapCreateEventPanel extends StatefulWidget{
  void Function() onDismissClicked;
  void Function(MapEventData) onApplyClicked;

  @override
  State<StatefulWidget> createState() => _MapCreateEventPanel();

  MapCreateEventPanel(this.onDismissClicked ,  this.onApplyClicked);
}

class _MapCreateEventPanel extends State<MapCreateEventPanel>{
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController eventMaxParticipantsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DraggableScrollableSheet(
        minChildSize: 0.2,
        maxChildSize: 0.8,
        initialChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white
            ),
            child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.keyboard_return),
                          onPressed: _onDismissCreateEvent,
                          label: Text("X"),
                          //TODO add localisation
                        ),
                      ),
                      Text("Create Event")
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        TextField(
                          controller: eventNameController,
                          decoration: InputDecoration(
                            label: Text("Event Name")
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        TextField(
                          controller: eventDescriptionController,
                          decoration: InputDecoration(
                            label: Text("Event Description")
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        TextField(
                          controller: eventMaxParticipantsController,
                          decoration: InputDecoration(
                              label: Text("Max Participants")
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        DropdownButton(
                            items: items,
                            onChanged: onChanged
                        )
                        Text("data"),
                        Text("data"),
                        Text("data"),
                        Text("data"),
                        Text("data"),
                        Text("data"),
                        Text("data"),
                        Text("data"),
                        Text("data"),
                        Text("data"),
                        Text("data"),
                        Text("data"),
                        Text("data"),
                        Text("data"),
                        ElevatedButton(
                            onPressed: _onAppliedCreateEvent,
                            child: Text("Submit !"))
                      ],
                    ),
                  )
                ]
            ),
          );
        }
    );
  }

  void _onDismissCreateEvent(){
    widget.onDismissClicked();
  }

  void _onAppliedCreateEvent(){

    //widget.onApplyClicked();
  }

}