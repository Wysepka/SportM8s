import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/events/map_event_join_scroll_view.dart';
import 'package:sportm8s/events/map_event_top_panel.dart';
import 'package:sportm8s/map/engine/sport_event_repository.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/services/server_sport_service.dart';

import '../map/containers/map_event_panel_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapJoinEvent extends StatefulWidget
{
  MapEventData mapEventData;
  final Function(MapEventData mapEventData) onApplyJointEventEvent;
  final Function() onUserDeletedEvent;
  final ServerSportService serverSportService;
  final Future<void> Function(UserEventRequestType requestType) onUserButtonRequestSend;
  final SportEventRepository sportRepository;

  MapJoinEvent(this.mapEventData , this.onApplyJointEventEvent, this.serverSportService , this.onUserDeletedEvent , this.onUserButtonRequestSend , this.sportRepository, {super.key});

  @override
  State<StatefulWidget> createState() => _MapJoinEvent();

}

class _MapJoinEvent extends State<MapJoinEvent>{

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context);
    return _getJoinEventMainPanelWidget(l10n);
  }

  Widget _getJoinEventMainPanelWidget(AppLocalizations? l10n){
    return MapEventPanelContainer(
        child: Column(
          children: [
            Flexible(
                fit: FlexFit.loose,
                child: MapEventJoinScrollView(widget.mapEventData , widget.serverSportService ,_onUserDeletedEvent , _onUserButtonRequestSend , widget.sportRepository)
            ),
          ],
        )
    );
  }

  void _onUserDeletedEvent(){
    widget.onUserDeletedEvent();
  }

  Future<void> _onUserButtonRequestSend(UserEventRequestType requestType) async {
    await widget.onUserButtonRequestSend(requestType);
  }
}