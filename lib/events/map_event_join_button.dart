import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/dto/api_result.dart';
import 'package:sportm8s/services/server_sport_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../core/services/storage_service.dart';
import '../map/models/map_event_data.dart';

class MapEventJoinButton extends StatefulWidget{
  final ServerSportService _sportService;
  final MapEventData _mapEventData;
  void Function(UserEventRequestType request) _onButtonRequestSend;
  void Function() _onDeleteButtonClicked;

  MapEventJoinButton(this._sportService , this._mapEventData , this._onButtonRequestSend , this._onDeleteButtonClicked);

  @override
  State<StatefulWidget> createState() => _MapEventJoinButton();
}

class _MapEventJoinButton extends State<MapEventJoinButton>{

  bool _isSendingDataThroughNetwork = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                bool isCurrentUserCreator = false;
                ApiResult<bool> apiResult = results[1] as ApiResult<bool>;
                if(apiResult is OkResult<bool>){
                  isCurrentUserCreator = (apiResult).data;
                }

                bool alreadyParticipant = widget._mapEventData.participantsIDs.containsKey(userID);

                String sendingNetworkCurrentUserCreatorText = isCurrentUserCreator ? l10n?.map_Event_Button_Deleting ?? "Deleting..." : l10n?.map_Event_Button_Leaving ?? "Leaving...";
                String notSendingNetworkCurrentUserCreatorText = isCurrentUserCreator ? l10n?.map_Event_Button_Delete ?? "Delete Event" : l10n?.map_Event_Button_Leave ?? "Leave Event";

                String sendingThroughNetworkDisplayText = alreadyParticipant ? sendingNetworkCurrentUserCreatorText : l10n?.map_Event_Button_Joining ?? "Joining...";
                String notSendingThroughNetworkDisplayText = alreadyParticipant ? notSendingNetworkCurrentUserCreatorText : l10n?.map_Event_Button_Join ?? "Join Event";

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
                              widget._onDeleteButtonClicked();
                            }
                            else {
                              var result = await widget._sportService
                                  .leaveSportEvent(
                                  widget._mapEventData);
                              widget._onButtonRequestSend(UserEventRequestType.Leave);
                            }
                            setState(() {
                              _isSendingDataThroughNetwork = false;
                            });
                          }    // ⬅ disables & greys out the button
                      : () async {
                        setState(() {
                          _isSendingDataThroughNetwork = true;
                        });
                        var result = await widget._sportService.joinSportEvent(widget
                            ._mapEventData);
                        widget._onButtonRequestSend(UserEventRequestType.Join);
                        setState(() {
                          _isSendingDataThroughNetwork = false;
                        });
                      },
                    label: Text(_isSendingDataThroughNetwork ? sendingThroughNetworkDisplayText : notSendingThroughNetworkDisplayText),
                    icon: _isSendingDataThroughNetwork ?
                      SizedBox(
                          height: 28,
                          width: 28,
                          child: CircularProgressIndicator(),
                      ) :
                      Icon(
                          alreadyParticipant ? Icons.close : Icons.add_circle
                      ),
                  ),
                );
              }
          ),
        );
      },
    );
  }

}