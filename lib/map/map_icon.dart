import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/core/logger/logger_config.dart';
import 'package:sportm8s/core/utility/sport_utility.dart';
import 'package:sportm8s/map/models/map_event_data.dart';

import '../core/utility/random_utility.dart';

class MapIcon extends GestureDetector{

  final double Function() zoomMultiplierFunc;
  late MapEventData? mapEventData;

  MapIcon(this.zoomMultiplierFunc, {super.key});

  @override
  Widget build(BuildContext context) {
    if(mapEventData == null) {
      return _getMarkerChild_Test(zoomMultiplierFunc);
    }
    else{
      return _getMarkerChild_SportEvent(zoomMultiplierFunc);
    }
  }


  Widget _getMarkerChild_SportEvent(double Function() getZoomMultiplier){
    return GestureDetector(
      child:
      Column(
        children: [
          ImageIcon(SportEventUtils.getIconBasedOnSportEventType(mapEventData!.sportEventType, 40)),
          ClipRRect(
              borderRadius: BorderRadius.circular(10 * getZoomMultiplier()),
              child: Container(
                padding: EdgeInsets.all(4 * getZoomMultiplier()),
                constraints: BoxConstraints(
                    minWidth: 120 * getZoomMultiplier(),
                    maxWidth: 160 * getZoomMultiplier(),
                    minHeight: 200 * getZoomMultiplier(),
                    maxHeight: 360 * getZoomMultiplier()),
                decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        8 * getZoomMultiplier()),
                    border: Border.all(
                        color: Colors.cyan, width: 8 * getZoomMultiplier())),
                child: Column(
                    children: [
                      Text("Name: ${mapEventData!.eventName}",
                        style: TextStyle(fontSize: 20 * getZoomMultiplier()),
                        textAlign: TextAlign.center,),
                      Text("Description: ${mapEventData!.eventDescription}",
                        style: TextStyle(fontSize: 15 * getZoomMultiplier()),
                        textAlign: TextAlign.center,),
                      Text("Participants: " '${mapEventData!.currentParticipants}/${mapEventData
                          !.maxParticipants}',
                        style: TextStyle(fontSize: 20 * getZoomMultiplier()),
                        textAlign: TextAlign.center,),
                      Text("Type: ${SportEventUtils.parseIntToSportEvenType(mapEventData!.sportEventType.index)}",
                        style: TextStyle(fontSize: 20 * getZoomMultiplier()),
                        textAlign: TextAlign.center,),
                    ]),
              )),
        ],
      ),
    );
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