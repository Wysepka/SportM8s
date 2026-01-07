import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/extensions/string_extensions.dart';
import 'package:sportm8s/dto/api_result.dart';
import 'package:sportm8s/dto/list_response.dart';
import 'package:sportm8s/events/map_event_join_button.dart';
import 'package:sportm8s/events/map_event_participant_widget.dart';
import 'package:sportm8s/events/map_event_widget_container.dart';
import 'package:sportm8s/map/containers/map_event_panel_container.dart';
import 'package:sportm8s/map/engine/sport_event_controller.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/services/server_sport_service.dart';
import 'package:sportm8s/services/server_user_service.dart';

import '../core/services/storage_service.dart';

class MapEventJoinScrollView extends StatefulWidget{
  final MapEventData mapEventData;
  final ServerSportService sportService;
  final Function() onUserDeletedEvent;

  MapEventJoinScrollView(this.mapEventData , this.sportService , this.onUserDeletedEvent);

  @override
  State<StatefulWidget> createState() => _MapEventJoinScrollView();
}

class _MapEventJoinScrollView extends State<MapEventJoinScrollView>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: [
        MapEventWidgetContainer(
            child: Column(children: [
              Text("Event Name"),
              Text(widget.mapEventData.eventName),
            ])
        ),
        MapEventWidgetContainer(
            child: Column(children: [
              Text("Event Description"),
              Text(widget.mapEventData.eventDescription),
            ])
        ),
        MapEventWidgetContainer(
            child: Column(children: [
              Text("Event Type"),
              Text(widget.mapEventData.sportEventType.toString()),
            ])
        ),
        MapEventWidgetContainer(
            child: Column(children: [
              Text("Event Start Date"),
              Text(widget.mapEventData.eventStartDate.toDate()),
            ])
        ),
        MapEventWidgetContainer(
            child: Column(children: [
              Text("Event Time"),
              Text(widget.mapEventData.eventDuration.to24h()),
            ])
        ),

        MapEventWidgetContainer(
            child: Column(children: [
              Text("Event Participants"),
              FutureBuilder<List<String>>(
                future: _getEventParticipantsDisplayNames(),
                builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(snapshot.hasError){
                    return Center(
                      child: Text("Could not Load Participants | E:${snapshot.error}"),
                    );
                  }
                  if(!snapshot.hasData){
                    return Center(
                      child: Text("No Participants, this is error since there should be at least one participant"),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return MapEventParticipantWidget(snapshot.data![index], 20, widget.mapEventData.participantsIDs.keys.elementAt(index) , index);
                      }
                  );
                },
              ),

            ])
        ),
        MapEventJoinButton(widget.sportService,widget.mapEventData , _onUserEventButtonRequestReceived , _onUserDeletedEvent),
        SizedBox(
          height: 48,
        )
      ],
    );
  }

  void _onUserEventButtonRequestReceived(UserEventRequestType requestType){
    setState(() {
    });
  }

  void _onUserDeletedEvent(){
    widget.onUserDeletedEvent();
  }

  Future<List<String>> _getEventParticipantsDisplayNames() async {
    final result = await widget.sportService.getMapEventParticipantsDisplayNames(widget.mapEventData);
    if(result.success ) {
      return (result as OkResult<ListResponse<String>>).data.items;
    }
    else{
      return [];
    }
  }

}