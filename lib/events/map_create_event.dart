

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/utility/sport_utility.dart';
import 'package:sportm8s/services/server_sport_service.dart';

import '../map/models/map_event_data.dart';

class MapCreateEventPanel extends StatefulWidget{
  void Function() onDismissClicked;
  void Function(MapEventData) onApplyClicked;
  ServerSportService serverSportService;

  @override
  State<StatefulWidget> createState() => _MapCreateEventPanel();

  MapCreateEventPanel(this.onDismissClicked ,  this.onApplyClicked , this.serverSportService);
}

class _MapCreateEventPanel extends State<MapCreateEventPanel>{
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController eventMaxParticipantsController = TextEditingController();

  String eventNameValue = "EventName";
  String eventDescriptionValue = "EventDescription";
  String maxParticipantsStringValue = "MaxParticipants";
  int maxParticipantsValue = 0;
  SportEventType sportEventTypeValue = SportEventType.Invalid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventNameController.addListener(_onEventNameChanged);
    eventDescriptionController.addListener(_onEventDescriptionChanged);
    eventMaxParticipantsController.addListener(_onEventMaxParticipantsChanged);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventNameController.removeListener(_onEventNameChanged);
    eventDescriptionController.removeListener(_onEventDescriptionChanged);
    eventMaxParticipantsController.removeListener(_onEventMaxParticipantsChanged);
  }

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
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey,
                  width: 8,
                ),
                color: Colors.white,
                boxShadow:[ BoxShadow(
                  color: Colors.grey, // shadow color
                  blurRadius: 8,                         // softens the shadow
                  spreadRadius: 1,                       // extends the shadow
                  offset: Offset(2, 4),                  // moves shadow right & down
              ),]
            ),
            child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow:[ BoxShadow(
                            color: Colors.white.withOpacity(0.5), // shadow color
                            blurRadius: 4,                         // softens the shadow
                            spreadRadius: 4,                       // extends the shadow
                            offset: Offset(1, 2),                  // moves shadow right & down
                          ),],
                          borderRadius:BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.grey,
                            width: 6
                          )
                        ),

                        child: Align(
                          //widthFactor: 0.1,
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.keyboard_return),
                            onPressed: _onDismissCreateEvent,
                            label: Text(
                              '',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),),
                            //TODO add localisation
                          ),
                        ),
                      ),
                      Container(
                          /*
                          decoration: BoxDecoration(
                              borderRadius:BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 6
                              ),
                              color: Colors.white24
                          ),

                           */
                          child: Text(
                              "Create Event",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                          )
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey ,
                                width: 2),
                            boxShadow:[ BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // shadow color
                              blurRadius: 4,                         // softens the shadow
                              spreadRadius: 0,                       // extends the shadow
                              offset: Offset(1, 2),                  // moves shadow right & down
                            ),],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Event Name",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextField(
                                textAlign: TextAlign.center,
                                controller: eventNameController,
                                decoration: InputDecoration(
                                  label: Text(eventNameController.text.isNotEmpty ? "" : "Event Name"),
                                  contentPadding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 0,
                                    bottom: 5,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey ,
                              width: 2),
                            boxShadow:[ BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // shadow color
                              blurRadius: 4,                         // softens the shadow
                              spreadRadius: 0,                       // extends the shadow
                              offset: Offset(1, 2),                  // moves shadow right & down
                            ),],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Event Description",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextField(
                                textAlign: TextAlign.center,
                                controller: eventDescriptionController,
                                decoration: InputDecoration(
                                  label: Text(eventDescriptionController.text.isNotEmpty ? "" : "Event Description"),
                                  contentPadding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 5,
                                    bottom: 15,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey ,
                              width: 2),
                            boxShadow:[ BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // shadow color
                              blurRadius: 4,                         // softens the shadow
                              spreadRadius: 0,                       // extends the shadow
                              offset: Offset(1, 2),                  // moves shadow right & down
                            ),],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Max Participants",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextField(
                                textAlign: TextAlign.center,
                                controller: eventMaxParticipantsController,
                                decoration: InputDecoration(
                                    label: Text(eventMaxParticipantsController.text.isNotEmpty ? "" : "Max Participants"),
                                    contentPadding: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: 5,
                                      bottom: 15,
                                    ),
                                    border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey ,
                              width: 2),
                            boxShadow:[ BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // shadow color
                              blurRadius: 4,                         // softens the shadow
                              spreadRadius: 0,                       // extends the shadow
                              offset: Offset(1, 2),                  // moves shadow right & down
                            ),],
                          ),
                          child:
                            Column(
                                children: [
                                  Text(
                                    "Sport Type",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SportEventUtils.getSportTypeDropdownButton(_onDropdownSportEventTypeChanged , _getSelectedSportEventType ,20)
                                ]
                            ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey ,
                                width: 2),
                            boxShadow:[ BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // shadow color
                              blurRadius: 4,                         // softens the shadow
                              spreadRadius: 0,                       // extends the shadow
                              offset: Offset(1, 2),                  // moves shadow right & down
                            ),],
                          ),
                          child:
                          Column(
                              children: [
                                Text(
                                  "Event Start Date",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ]
                          ),
                        ),
                        /*
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

                         */
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

  String _getSelectedSportEventType(){
    return sportEventTypeValue.name.split('.').last;
  }

  void _onDismissCreateEvent(){
    widget.onDismissClicked();
  }

  void _onAppliedCreateEvent(){
    MapEventData mapEventData = MapEventData(
        eventName: eventNameValue,
        eventDescription: eventDescriptionValue,
        sportEventType: sportEventTypeValue,
        //This is zero, but in MapSideView is providing a value
        position: LatLng(0, 0),
        maxParticipants: maxParticipantsValue,
        currentParticipants: 1,
        eventID: "",
        creatorID: "",
        participantsIDs: [],
    );
    widget.onApplyClicked(mapEventData);
    //widget.onApplyClicked();
  }

  void _onDropdownSportEventTypeChanged(String? value){
    if(value != null) {
      setState(() {
        sportEventTypeValue = SportEventType.values.firstWhere(
                (e) => e.name.toLowerCase() == value.toLowerCase(),
            orElse: () => SportEventType.Invalid);
      });
    }
  }

  void _onEventNameChanged(){
    setState(() {
      eventNameValue = eventNameController.text;
    });
  }

  void _onEventDescriptionChanged(){
    setState(() {
      eventDescriptionValue = eventNameController.text;
    });
  }
  void _onEventMaxParticipantsChanged(){
    maxParticipantsStringValue = eventMaxParticipantsController.text;
    int? possibleValue = int.tryParse(maxParticipantsStringValue);
    if(possibleValue != null){
      setState(() {
        maxParticipantsValue = possibleValue;
      });
    }
  }


}