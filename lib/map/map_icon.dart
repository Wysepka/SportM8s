import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/core/logger/logger_config.dart';

import '../core/utility/random_utility.dart';

class MapIcon extends GestureDetector{

  final double Function() zoomMultiplierFunc;

  MapIcon(this.zoomMultiplierFunc, {super.key});

  @override
  Widget build(BuildContext context) {
    return _getMarkerChild_Test(zoomMultiplierFunc);
  }

  Widget _getMarkerChild_SportEvent(double Function() getZoomMultiplier){

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