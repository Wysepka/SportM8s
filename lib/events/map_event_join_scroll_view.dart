import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/extensions/string_extensions.dart';
import 'package:sportm8s/core/styles/map_event_widget_text_style.dart';
import 'package:sportm8s/dto/api_result.dart';
import 'package:sportm8s/dto/list_response.dart';
import 'package:sportm8s/events/map_event_join_button.dart';
import 'package:sportm8s/events/map_event_participant_widget.dart';
import 'package:sportm8s/events/map_event_widget_container.dart';
import 'package:sportm8s/map/engine/sport_event_repository.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/services/server_sport_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MapEventJoinScrollView extends StatefulWidget{
  MapEventData mapEventData;
  final ServerSportService sportService;
  final SportEventRepository sportRepository;
  final Function() onUserDeletedEvent;
  final Future<void> Function(UserEventRequestType requestType) onUserButtonRequestSend;

  MapEventJoinScrollView(this.mapEventData , this.sportService , this.onUserDeletedEvent, this.onUserButtonRequestSend , this.sportRepository);

  @override
  State<StatefulWidget> createState() => _MapEventJoinScrollView();
}

class _MapEventJoinScrollView extends State<MapEventJoinScrollView>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final l10n = AppLocalizations.of(context);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ListView(
      children: [
        MapEventWidgetContainer(
            child: Column(children: [
              Text(
                l10n?.event_Title_EventName ?? "Event Name",
                style: Theme.of(context).textTheme.titleMedium?.mapEventWidgetTitle(context),
              ),
              Text(widget.mapEventData.eventName),
            ])
        ),
        MapEventWidgetContainer(
            child: Column(children: [
              Text(
                l10n?.event_Title_EventDescription ?? "Event Description",
                style: Theme.of(context).textTheme.titleMedium?.mapEventWidgetTitle(context),
              ),
              Text(widget.mapEventData.eventDescription),
            ])
        ),
        MapEventWidgetContainer(
            child: Column(children: [
              Text(
                l10n?.event_Title_EventType ?? "Event Type",
                style: Theme.of(context).textTheme.titleMedium?.mapEventWidgetTitle(context),
              ),
              Text(widget.mapEventData.sportEventType.toString()),
            ])
        ),
        MapEventWidgetContainer(
            child: Column(children: [
              Text(
                l10n?.event_Title_EventStartDate ?? "Event Start Date",
                style: Theme.of(context).textTheme.titleMedium?.mapEventWidgetTitle(context),
              ),
              Text(widget.mapEventData.eventStartDate.toDate()),
            ])
        ),
        MapEventWidgetContainer(
            child: Column(children: [
              Text(
                l10n?.event_Title_EventStartTime ?? "Event Time",
                style: Theme.of(context).textTheme.titleMedium?.mapEventWidgetTitle(context),
              ),
              Text(widget.mapEventData.eventDuration.to24h()),
            ])
        ),

        MapEventWidgetContainer(
            child: Column(children: [
              Text(
                  l10n?.event_Title_EventParticipants ?? "Event Participants",
                  style: Theme.of(context).textTheme.titleMedium?.mapEventWidgetTitle(context),
              ),
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

  void _onUserEventButtonRequestReceived(UserEventRequestType requestType) async {
    await widget.onUserButtonRequestSend(requestType);
    setState(() {
      var tryGetMapEventUpdated = widget.sportRepository.getMapSportEventDataBasedOnID(widget.mapEventData.eventID);
      if(tryGetMapEventUpdated.success){
        widget.mapEventData = tryGetMapEventUpdated.data!.eventData;
      }
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