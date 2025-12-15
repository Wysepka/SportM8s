

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/utility/sport_utility.dart';
import 'package:sportm8s/events/map_create_event_date_picker.dart';
import 'package:sportm8s/events/map_event_widget_container.dart';
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

  bool eventNameSelected = false;
  String eventNameValue = "EventName";
  bool eventDescriptionSelected = false;
  String eventDescriptionValue = "EventDescription";
  String maxParticipantsStringValue = "MaxParticipants";
  bool maxParticipantsSelected = false;
  int maxParticipantsValue = 0;
  bool sportEventTypeSelected = false;
  SportEventType sportEventTypeValue = SportEventType.Invalid;
  bool eventDataSelected = false;
  DateTime? eventDate;
  bool eventTimeSelected = false;
  TimeOfDay? eventTime;

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
                        MapCreateEventDatePicker(_onEventDateTimeSelected, eventDate, _onEventTimeOfDatSelected , eventTime),
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
    if(_checkIfMissingSomeData()){
      return;
    }

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
        eventStartDate: eventDate!,
        eventDuration: eventTime!
    );
    widget.onApplyClicked(mapEventData);
    //widget.onApplyClicked();
  }

  bool _checkIfMissingSomeData(){
    if(!eventNameSelected){
      _showMissingDataSnackbar("Event Name not edited, Write Event Name.");
      return true;
    }

    if(!eventDescriptionSelected){
      _showMissingDataSnackbar("Event Description not edited, Write Event Description");
      return true;
    }

    if(!sportEventTypeSelected){
      _showMissingDataSnackbar("Event Type not selected. Choose activity type");
      return true;
    }

    if(!maxParticipantsSelected){
      _showMissingDataSnackbar("Max Participants not selected , choose how many Sport M8s can join");
      return true;
    }

    if(!eventDataSelected){
      _showMissingDataSnackbar("Event Date not selected. Select Date of this activity");
      return true;
    }

    if(!eventTimeSelected){
      _showMissingDataSnackbar("Event Time not selected. Select time of this Activity");
      return true;
    }

    return false;
  }

  void _showMissingDataSnackbar(String info){
    if(context.mounted){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info)));
    }
  }

  void _onDropdownSportEventTypeChanged(String? value){
    if(value != null) {
      setState(() {
        sportEventTypeValue = SportEventType.values.firstWhere(
                (e) => e.name.toLowerCase() == value.toLowerCase(),
            orElse: () => SportEventType.Invalid);
        if(sportEventTypeValue != SportEventType.Invalid){
          sportEventTypeSelected = true;
        }
      });
    }
  }

  void _onEventNameChanged(){
    setState(() {
      eventNameValue = eventNameController.text;
      if(eventNameValue.isNotEmpty){
        eventNameSelected = true;
      }
    });
  }

  void _onEventDescriptionChanged(){
    setState(() {
      eventDescriptionValue = eventNameController.text;
      if(eventDescriptionValue.isNotEmpty){
        eventDescriptionSelected = true;
      }
    });
  }
  void _onEventMaxParticipantsChanged(){
    maxParticipantsStringValue = eventMaxParticipantsController.text;
    int? possibleValue = int.tryParse(maxParticipantsStringValue);
    if(possibleValue != null){
      setState(() {
        maxParticipantsValue = possibleValue;
        if(maxParticipantsValue > 0){
          maxParticipantsSelected = true;
        }
      });
    }
  }

  void _onEventDateTimeSelected(DateTime dateTime){
    setState(() {
      eventDataSelected = true;
      eventDate = dateTime;
    });
  }

  void _onEventTimeOfDatSelected(TimeOfDay timeOfDay){
    setState(() {
      eventTimeSelected = true;
      eventTime = timeOfDay;
    });
  }

}