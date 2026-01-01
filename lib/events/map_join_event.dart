import 'package:flutter/cupertino.dart';
import 'package:sportm8s/events/map_event_join_scroll_view.dart';
import 'package:sportm8s/events/map_event_top_panel.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/services/server_sport_service.dart';

import '../map/containers/map_event_panel_container.dart';

class MapJoinEvent extends StatefulWidget
{
  MapEventData mapEventData;
  final Function() onDismissJoinEventEvent;
  final Function(MapEventData mapEventData) onApplyJointEventEvent;
  final ServerSportService serverSportService;

  MapJoinEvent(this.mapEventData , this.onApplyJointEventEvent, this.onDismissJoinEventEvent , this.serverSportService);

  @override
  State<StatefulWidget> createState() => _MapJoinEvent();

}

class _MapJoinEvent extends State<MapJoinEvent>{
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        minChildSize: 0.2,
        maxChildSize: 0.8,
        initialChildSize: 0.5,
        builder: (context, scrollController) {
          return MapEventPanelContainer(
              child: Column(
                children: [
                  MapEventTopPanel(_onDismissJoinEvent, "Join Event"),
                  Flexible(
                      fit: FlexFit.loose,
                      child: MapEventJoinScrollView(widget.mapEventData , widget.serverSportService)
                  ),
                ],
              )
          );
        }
    );
  }

  void _onDismissJoinEvent(){
    widget.onDismissJoinEventEvent();
  }
}