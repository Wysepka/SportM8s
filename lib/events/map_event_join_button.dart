import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/services/server_sport_service.dart';

import '../core/services/storage_service.dart';
import '../map/models/map_event_data.dart';

class MapEventJoinButton extends StatefulWidget{
  final ServerSportService _sportService;
  final MapEventData _mapEventData;
  void Function(UserEventRequestType request) _onButtonRequestReceived;

  MapEventJoinButton(this._sportService , this._mapEventData , this._onButtonRequestReceived);

  @override
  State<StatefulWidget> createState() => _MapEventJoinButton();
}

class _MapEventJoinButton extends State<MapEventJoinButton>{

  bool _isSendingDataThroughNetwork = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final storageService = ref.watch(storageServiceInitializerProvider);
        return storageService.when(
          loading: () => SizedBox(
            height: 28,
            child: FilledButton(
                onPressed: null,
                child: Center(child: Text("Could not load User ID"),)
            ),
          ),
          error: (error , _) => Center(
            child: Text("Error: ${error}"),),
          data: (data) => FutureBuilder(
              future: Future.wait([
                  data.getUserID(ref),
                  widget._sportService.getIsCurrentUserEventCreator(widget._mapEventData.eventID)
              ]),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return SizedBox(
                    height: 48,
                    child: Center(
                      child: CircularProgressIndicator(),),
                  );
                }
                if(snapshot.hasError){
                  return SizedBox(
                    height: 48,
                    child: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                }
                if(!snapshot.hasData){
                  return SizedBox(
                    height: 48,
                    child: Center(
                      child: Text("No Data, Cannot join"),
                    ),
                  );
                }
                final results = snapshot.data!;
                String userID = results[0] as String;
                bool isCurrentUserCreator = results[1] as bool;
                bool alreadyParticipant = widget._mapEventData.participantsIDs.containsKey(userID);

                String sendingThroughNetworkDisplayText = alreadyParticipant ? isCurrentUserCreator ? "Deleting..." : "Leaving..." : "Joining...";
                String notSendingThroughNetworkDisplayText = alreadyParticipant ? isCurrentUserCreator ? "Delete Event" : "Leave Event" : "Join Event";

                return SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _isSendingDataThroughNetwork ? null :
                      alreadyParticipant
                          ? () async {
                          setState(() {
                            _isSendingDataThroughNetwork = true;
                          });
                          if(isCurrentUserCreator){
                            var result = await widget._sportService.deleteSportEvent(widget._mapEventData);
                          }
                          else {
                            var result = await widget._sportService
                                .leaveSportEvent(
                                widget._mapEventData);
                          }
                          setState(() {
                            _isSendingDataThroughNetwork = false;
                          });
                          }    // ⬅ disables & greys out the button
                          : () {
                        setState(() {
                          _isSendingDataThroughNetwork = true;
                        });
                        widget._sportService.joinSportEvent(widget
                            ._mapEventData);
                        setState(() {
                          _isSendingDataThroughNetwork = false;
                        });
                      },
                    label: Text(_isSendingDataThroughNetwork ? sendingThroughNetworkDisplayText : notSendingThroughNetworkDisplayText),
                    icon: _isSendingDataThroughNetwork ? CircularProgressIndicator() : Icon(alreadyParticipant ? Icons.close : Icons.add_circle),
                  ),
                );
              }
          ),
        );
      },
    );
  }

}