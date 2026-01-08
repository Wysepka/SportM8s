import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/core/styles/map_event_widget_text_style.dart';
import 'package:sportm8s/map/panels/map_view_bottom_panel_controller.dart';

import '../../core/enums/enums_container.dart';

class MapViewBottomPanel extends StatefulWidget{

  final MapViewBottomPanelController controller;
  final void Function() onCreateEventEvent;
  final void Function() onJoinEventEvent;

  MapViewBottomPanel(this.controller, this.onCreateEventEvent , this.onJoinEventEvent);

  @override
  State<StatefulWidget> createState() => _MapViewBottomPanel();

}

class _MapViewBottomPanel extends State<MapViewBottomPanel>{

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.controller.removeListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant MapViewBottomPanel oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(oldWidget != widget){
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  void _onControllerChanged(){
    if(!mounted){return;}

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.controller.bottomPanelType == MapViewBottomPanelType.Invalid){
      return Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: Container(
              color: Colors.white38.withOpacity(0.5),
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text("Loading...")
                  ],
                ),
              ),
            ),
          )
      );
    }
    else if(widget.controller.bottomPanelType == MapViewBottomPanelType.CreatingEvent) {
      return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: SizedBox(
          width: double.infinity,
          height: 80,
          child: _getMapEventPopupButton("   Create Event", widget.onCreateEventEvent)
        ),
      );
    }
    else if(widget.controller.bottomPanelType == MapViewBottomPanelType.JoiningEvent){
      return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: SizedBox(
          width: double.infinity,
          height: 80,
          child: _getMapEventPopupButton("   Join Event", widget.onJoinEventEvent)
        ),
      );
    }
    else{
      return SizedBox.shrink();
    }
  }

  Widget _getMapEventPopupButton(String buttonLabel, Function() onClicked){
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      child: Material(
        elevation: 8,
        shadowColor: colorScheme.shadow,
        borderRadius: BorderRadius.circular(20),
        child: ElevatedButton.icon(
            icon: Icon(
              Icons.add,
              size: 35 ,
              color: Colors.white,
            ),
            onPressed: onClicked,
            //TODO Add localisation
            label: Text(
              buttonLabel,
              style: Theme.of(context).textTheme.titleLarge?.mapEventWidgetTitle(context),
            ),
        ),
      ),
    );
  }

}