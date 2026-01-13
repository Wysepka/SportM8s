import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/extensions/string_extensions.dart';
import 'package:sportm8s/core/logger/logger_config.dart';
import 'package:sportm8s/core/utility/event_utility.dart';
import 'package:sportm8s/core/utility/sport_utility.dart';
import 'package:sportm8s/map/models/map_event_data.dart';
import 'package:sportm8s/map/icon/marker_info_row.dart';
import 'package:sportm8s/map/models/map_marker_rect.dart';
import 'package:sportm8s/map/models/map_sport_event_marker.dart';

import '../../core/utility/random_utility.dart';
import 'map_icon_controller.dart';

class MapIcon extends StatefulWidget{

  final double Function() zoomMultiplierFunc;
  final MapIconController controller;
  final MapEventData mapEventData;

  final void Function(MapMarkerRect mapMarkerRect)? onPanelGeometryChanged;
  final void Function(MapEventData mapEventData) onMapIconClicked;

  MapIcon(this.zoomMultiplierFunc,this.onPanelGeometryChanged, this.onMapIconClicked , this.controller, this.mapEventData);

  @override
  State<StatefulWidget> createState() => _MapIcon();
}

class _MapIcon extends State<MapIcon>{

  final GlobalKey _textContainerKey = GlobalKey();

  MapIconController get mapIconController => widget.controller;

  @override
  void initState() {
    // TODO: implement didChangeDependencies
    super.initState();
    mapIconController.addListener(_onControllerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => measurePanel());
  }

  @override
  void didUpdateWidget(covariant MapIcon oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(oldWidget.controller != widget.controller){
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => measurePanel());
  }

  @override
  Widget build(BuildContext context) {
      return _getMarkerChild_SportEventV2(widget.zoomMultiplierFunc , context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.controller.removeListener(_onControllerChanged);
  }

  void _onControllerChanged()
  {
    if(!mounted){return;}

    setState(() {

    });

    WidgetsBinding.instance.addPostFrameCallback((_) => measurePanel());
  }

  Widget _getMarkerChild_SportEvent(double Function() getZoomMultiplier){
    double sportIconSize = 60 * getZoomMultiplier();
    MapEventData? mapEventData = widget.mapEventData;
    Image sportEventAssetImage = SportEventUtils.getTransparentIconBasedOnSportEventType(mapEventData!.sportEventType , sportIconSize , sportIconSize);
    return GestureDetector(
      child:
      Column(
        mainAxisSize: MainAxisSize.min,          // <- important
        children: [
          SizedBox(width: 60 * getZoomMultiplier() , height:  60 * getZoomMultiplier() , child: sportEventAssetImage),
          ClipRRect(
              borderRadius: BorderRadius.circular(10 * getZoomMultiplier()),
              child: Container(
                padding: EdgeInsets.all(4 * getZoomMultiplier()),
                constraints: BoxConstraints(
                    minWidth: 120,
                    maxWidth: 160,
                    minHeight: 200,
                    maxHeight: 360,),
                decoration: BoxDecoration(color: SportEventUtils.getSportEventBackgroundColor(type: mapEventData!.sportEventType),
                    borderRadius: BorderRadius.circular(
                        8 * getZoomMultiplier()),
                    border: Border.all(
                        color: SportEventUtils.getSportEventColor(mapEventData!.sportEventType), width: 8 * getZoomMultiplier())),
                //child: Flexible(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,          // <- important
                      children: [
                        RichText(
                            text: TextSpan(
                                style: TextStyle(fontSize: 20 * getZoomMultiplier() , color: Colors.black),
                                children: [
                                  WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: EventUtility.GetEventIconBasedOnEventParam(EventParamType.EventName ,18 , 18)),
                                  TextSpan(
                                      text: mapEventData!.eventName
                                  ),
                                ]
                            )),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(fontSize: 20 * getZoomMultiplier() , color: Colors.black),
                                children: [
                                  WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: EventUtility.GetEventIconBasedOnEventParam(EventParamType.EventDescription ,18 , 18)),
                                  TextSpan(
                                      text: mapEventData!.eventDescription
                                  ),
                                ]
                            )),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(fontSize: 20 * getZoomMultiplier() , color: Colors.black),
                                children: [
                                  WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: EventUtility.GetEventIconBasedOnEventParam(EventParamType.EventParticipants ,18, 18)),
                                  TextSpan(
                                      text: '${mapEventData!.capacity.currentParticipants}/${mapEventData!.capacity.maxParticipants}'
                                  ),
                                ]
                            )),
                        RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 20 * getZoomMultiplier() , color: Colors.black),
                              children: [
                                WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: SportEventUtils.getTransparentIconBasedOnSportEventType(mapEventData!.sportEventType , 18 , 18)),
                                TextSpan(
                                    text: SportEventUtils.getSportNameLocalisedBasedOnSportEventType(mapEventData!.sportEventType)
                                ),
                              ]
                        ))
                      ]),
                //),
              )),
        ],
      ),
    );
  }


  Widget _getMarkerChild_SportEventV2(double Function() getZoomMultiplier , BuildContext context) {
    final zoom = getZoomMultiplier();
    final double sportIconSize = 60 * zoom;
    final sportType = widget.mapEventData.sportEventType;
    MapEventData mapEventData = widget.mapEventData;

    final Image sportEventAssetImage =
    SportEventUtils.getTransparentIconBasedOnSportEventType(
      sportType,
      sportIconSize,
      sportIconSize,
    );

    return GestureDetector(
      onTap: () => widget.onMapIconClicked(widget.mapEventData),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TOP ICON
          SizedBox(
            width: sportIconSize,
            height: sportIconSize,
            child: sportEventAssetImage,
          ),

          SizedBox(height: 4 * zoom),

          // PANEL
          IgnorePointer(
            ignoring: mapIconController.isColliding,
            child: Opacity(
              opacity: mapIconController.isColliding ? 0 : 1,
              child: Container(
                key: _textContainerKey,
                padding: EdgeInsets.all(6 * zoom),
                constraints: const BoxConstraints(
                  minWidth: 120,
                  maxWidth: 180,   // good for marker, not too wide
                  minHeight: 80,
                  maxHeight: 260,  // keep it reasonable on map
                ),
                decoration: BoxDecoration(
                  color: SportEventUtils.getSportEventBackgroundColor(type: sportType),
                  borderRadius: BorderRadius.circular(10 * zoom),
                  border: Border.all(
                    color: SportEventUtils.getSportEventColor(sportType),
                    width: 3 * zoom,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4 * zoom,
                      offset: Offset(0, 2 * zoom),
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12 * zoom,
                    color: Colors.black,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // EVENT NAME (title)
                      MarkerInfoRow(
                        zoom: zoom,
                        icon: EventUtility.GetEventIconBasedOnEventParam(
                          EventParamType.EventName,
                          18,
                          18,
                        ),
                        text: mapEventData!.eventName,
                        maxLines: 1,
                        isTitle: true,
                      ),

                      SizedBox(height: 2 * zoom),

                      // DESCRIPTION
                      MarkerInfoRow(
                        zoom: zoom,
                        icon: EventUtility.GetEventIconBasedOnEventParam(
                          EventParamType.EventDescription,
                          18,
                          18,
                        ),
                        text: mapEventData!.eventDescription,
                        maxLines: 2, // description can be a bit longer
                      ),

                      SizedBox(height: 2 * zoom),

                      // PARTICIPANTS
                      MarkerInfoRow(
                        zoom: zoom,
                        icon: EventUtility.GetEventIconBasedOnEventParam(
                          EventParamType.EventParticipants,
                          18,
                          18,
                        ),
                        text:
                        '${mapEventData!.capacity.currentParticipants}/${mapEventData!.capacity.maxParticipants}',
                        maxLines: 1,
                      ),

                      SizedBox(height: 2 * zoom),

                      // SPORT TYPE
                      MarkerInfoRow(
                        zoom: zoom,
                        icon: SportEventUtils.getTransparentIconBasedOnSportEventType(
                          sportType,
                          18,
                          18,
                        ),
                        text: SportEventUtils
                            .getSportNameLocalisedBasedOnSportEventType(sportType),
                        maxLines: 1,
                      ),

                      SizedBox(height: 2 * zoom),

                      MarkerInfoRow(
                        zoom: zoom,
                        icon: EventUtility.GetEventIconBasedOnEventParam(
                            EventParamType.EventDate,
                            18,
                            18
                        ),
                        text: mapEventData!.eventStartDate.toDate(),
                        maxLines: 1,
                      ),

                      SizedBox(height: 2 * zoom),

                      MarkerInfoRow(
                        zoom: zoom,
                        icon: EventUtility.GetEventIconBasedOnEventParam(
                            EventParamType.EventTime,
                            18,
                            18
                        ),
                        text: mapEventData!.eventDuration.to24h(),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void measurePanel() {
    final ctx = _textContainerKey.currentContext;
    if (ctx == null) return;

    final renderBox = ctx.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final size = renderBox.size;
    final topLeft = renderBox.localToGlobal(Offset.zero);

    // Rect in GLOBAL SCREEN COORDINATES
    final rect = Rect.fromLTWH(
      topLeft.dx,
      topLeft.dy,
      size.width,
      size.height,
    );

    // callback to parent
    widget.onPanelGeometryChanged!.call(MapMarkerRect(widget.mapEventData.eventID, rect , widget));
  }


  Widget _getMarkerChild_Test(double Function() getZoomMultiplier){
    String randomString = RandomUtility.randomString(10, 30);
    return GestureDetector(
      //onTap: () => LoggerConfig.logger.log(level: Level.debug , message: "On GestureDetector Tapped");
      onTap: () => log.d("Gesture Detector tapped"),
      child:
      Column(
        children: [
          Icon(Icons.location_on, size: 40 * getZoomMultiplier(), color: Colors.red),
          ClipRRect(
              borderRadius: BorderRadius.circular(25 * getZoomMultiplier()),
              child: Container(
                padding: EdgeInsets.all(4 * getZoomMultiplier()),
                constraints: BoxConstraints(minWidth:  10 * getZoomMultiplier() , maxWidth:  120 * getZoomMultiplier() ,minHeight:  10 * getZoomMultiplier(),maxHeight:  140 * getZoomMultiplier()),
                child: Text(randomString, style: TextStyle(fontSize: 20 * getZoomMultiplier()) , textAlign: TextAlign.center,),
                decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.circular(25 * getZoomMultiplier()) , border: Border.all(color: Colors.cyan ,width:  10 * getZoomMultiplier())),
              )),
        ],
      ),
    );
  }
}