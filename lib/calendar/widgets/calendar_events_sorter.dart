import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/calendar/widgets/calendar_text_icon_container.dart';
import 'package:sportm8s/graphics/sportm8s_themes.dart';

import '../../core/utility/sport_utility.dart';

class CalendarEventsSorter extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CalendarEventsSorter();

}

class _CalendarEventsSorter extends State<CalendarEventsSorter>{

  String selectedSportTypeString = "All";
  String selectedDistanceTypeString = "All";
  FocusNode selectedSportTypeFocusNode = FocusNode(debugLabel: "SelectedSportType_Sorter");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: CalendarTextIconContainer(SportM8sColors.primaryContainer, Icon(Icons.sort), "Sort by", Theme.of(context).textTheme.bodyLarge)
          ),
          SizedBox(width: 5,),
          Expanded(
              child: SportEventUtils.getSportTypeDropdownButton_Sorter(onSportTypeChanged , getSelectedSportTypeString, 20 , selectedSportTypeFocusNode ,context)
          ),
          SizedBox(width: 5,),
          Flexible(
            child: DropdownButton<String>(
                items: distanceDropdownButtons(),
                value: getSelectedDistanceTypeString(),
                isExpanded: true,
                onChanged: onDistanceDropdownChanged
            ),
          ),
        ],
      ),
    );
  }

  String getSelectedSportTypeString() => selectedSportTypeString;

  String getSelectedDistanceTypeString() => selectedDistanceTypeString;

  void onDistanceDropdownChanged(String? value){
    if(value != null) {
      setState(() {
        selectedDistanceTypeString = value;
      });
    }
  }

  void onSportTypeChanged(String? value){
    if(value != null){
      setState(() {
        selectedSportTypeString = value;
      });
    }
  }

  List<DropdownMenuItem<String>> distanceDropdownButtons(){
    List<DropdownMenuItem<String>> buttons = [
      DropdownMenuItem(
          value: "All",
          child: Text("All")
      ),
      DropdownMenuItem(
          value: "10km",
          child: Text("< 10km")
      ),
      DropdownMenuItem(
          value: "25km",
          child: Text("< 25km")
      ),
      DropdownMenuItem(
          value: "100km",
          child: Text("< 100km")
      ),
    ];
    return buttons;
  }

}