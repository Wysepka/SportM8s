

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/styles/map_event_widget_text_style.dart';
import 'package:sportm8s/core/utility/sport_utility.dart';
import 'package:sportm8s/events/map_create_event_date_picker.dart';
import 'package:sportm8s/events/map_event_top_panel.dart';
import 'package:sportm8s/events/map_event_widget_container.dart';
import '../map/containers/map_event_panel_container.dart';
import '../map/models/map_event_data.dart';
import '../services/server_sport_service.dart';

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

  double _currentDraggableSheetSize = 0.5;

  FocusNode nameFieldFocusNode = FocusNode(
      debugLabel:  "NameFieldFocusNode"
  );

  FocusNode descriptionFieldFocusNode = FocusNode(
    debugLabel: "DescriptionFieldFocusNode"
  );

  FocusNode maxParticipantsFocusNode = FocusNode(
    debugLabel: "MaxParticipantsFocusNode"
  );

  FocusNode sportTypeFocusNode = FocusNode(
    debugLabel: "SportTypeFocusNode"
  );

  int focusStack = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventNameController.addListener(_onEventNameChanged);
    eventDescriptionController.addListener(_onEventDescriptionChanged);
    eventMaxParticipantsController.addListener(_onEventMaxParticipantsChanged);

    nameFieldFocusNode.addListener(() => onFocusComponentChanged(nameFieldFocusNode));
    descriptionFieldFocusNode.addListener(() => onFocusComponentChanged(descriptionFieldFocusNode));
    maxParticipantsFocusNode.addListener(() => onFocusComponentChanged(maxParticipantsFocusNode));
    sportTypeFocusNode.addListener(() => onFocusComponentChanged(sportTypeFocusNode));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventNameController.removeListener(_onEventNameChanged);
    eventDescriptionController.removeListener(_onEventDescriptionChanged);
    eventMaxParticipantsController.removeListener(_onEventMaxParticipantsChanged);

    nameFieldFocusNode.dispose();
    descriptionFieldFocusNode.dispose();
    maxParticipantsFocusNode.dispose();
    sportTypeFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
        minChildSize: 0.2,
        maxChildSize: 0.9,
        initialChildSize: _currentDraggableSheetSize,
        builder: (context, scrollController) {
          return MapEventPanelContainer(
            child: Column(
                children: [
                  MapEventTopPanel(_onDismissCreateEvent, "Create Event"),
                  Expanded(
                    child: ListView(
                      children: [
                        MapEventWidgetContainer(
                          child: Column(
                            children: [
                              Text(
                                "Event Name",
                                style: Theme.of(context).textTheme.titleMedium?.mapEventWidgetTitle(context),
                              ),
                              TextField(
                                focusNode: nameFieldFocusNode,
                                textAlign: TextAlign.center,
                                controller: eventNameController,
                                minLines: 1,
                                maxLines: null,
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
                        MapEventWidgetContainer(
                          child: Column(
                            children: [
                              Text(
                                "Event Description",
                                style: Theme.of(context).textTheme.titleMedium?.mapEventWidgetTitle(context),
                              ),
                              TextField(
                                focusNode: descriptionFieldFocusNode,
                                textAlign: TextAlign.center,
                                controller: eventDescriptionController,
                                minLines: 1,
                                maxLines: null,
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
                        MapEventWidgetContainer(
                          child: Column(
                            children: [
                              Text(
                                "Max Participants",
                                style: Theme.of(context).textTheme.titleMedium?.mapEventWidgetTitle(context),
                              ),
                              TextField(
                                focusNode: maxParticipantsFocusNode,
                                textAlign: TextAlign.center,
                                controller: eventMaxParticipantsController,
                                minLines: 1,
                                maxLines: null,
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
                        MapEventWidgetContainer(
                          child:
                            Column(
                                children: [
                                  Text(
                                    "Sport Type",
                                    style: Theme.of(context).textTheme.titleMedium?.mapEventWidgetTitle(context),
                                  ),
                                  SportEventUtils.getSportTypeDropdownButton(_onDropdownSportEventTypeChanged , _getSelectedSportEventType ,20 , sportTypeFocusNode)
                                ]
                            ),
                        ),
                        MapCreateEventDatePicker(_onEventDateTimeSelected, eventDate, _onEventTimeOfDatSelected , eventTime),
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

  void onFocusComponentChanged(FocusNode focusNode){
    if(focusNode.hasFocus){
      focusStack++;
    }
    else{
      focusStack--;
    }

    setState(() {
      if(focusStack > 0){
        _currentDraggableSheetSize = 0.9;
      }
      else{
        _currentDraggableSheetSize = 0.5;
      }
    });
  }

  void onNameFocusNode(){
  }

  void onDescriptionFocusNode(){

  }

  void onMaxParticipantsFocusNode(){

  }

  void onSportTypeFocusNode(){

  }

  void updateDraggableSheetSize(){

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
        capacity: Capacity(maxParticipants: maxParticipantsValue, currentParticipants: 1),
        eventID: "",
        creatorID: "",
        participantsIDs: <String,Participant>{},
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
      eventDescriptionValue = eventDescriptionController.text;
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