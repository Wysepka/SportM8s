import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          height: 50,
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))
                ),
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow,
              ),
              icon: Icon(Icons.add, size: 35),
              onPressed: widget.onCreateEventEvent,
              //TODO Add localisation
              label: Text(
                "Create Event",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 35,
                ),
              )
          ),
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
          height: 50,
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)
                  ),
                ),
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow,
              ),
              icon: Icon(Icons.add, size: 35),
              onPressed: widget.onJoinEventEvent,
              //TODO Add localisation
              label: Text(
                "View Event",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 35,
                ),
              )
          ),
        ),
      );
    }
    else{
      return SizedBox.shrink();
    }
  }

}