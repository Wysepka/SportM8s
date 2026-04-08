import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportm8s/bloc/calendar_sorter/calendar_query_container_bloc.dart';
import 'package:sportm8s/bloc/calendar_sorter/calendar_query_container_event.dart';
import 'package:sportm8s/calendar/widgets/calendar_text_icon_container.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/utility/location_utility.dart';
import 'package:sportm8s/graphics/sportm8s_themes.dart';

import '../../core/utility/sport_utility.dart';

class CalendarEventsSorter extends StatefulWidget{
  const CalendarEventsSorter({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarEventsSorter();

}

class _CalendarEventsSorter extends State<CalendarEventsSorter>{

  String selectedSportTypeString = "All";
  SportEventType selectedSportEventType = SportEventType.Invalid; //Invalid serves as ALL
  String selectedDistanceTypeString = "All";
  EventDistanceQueryType selectedDistanceType = EventDistanceQueryType.All;
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
              child: SportEventUtils.getSportTypeDropdownButton_Sorter(
                  (stringValue) => onSportTypeChanged(stringValue , context) ,
                  getSelectedSportTypeString,
                  20 ,
                  selectedSportTypeFocusNode ,context
              )
          ),
          SizedBox(width: 5,),
          Flexible(
            child: DropdownButton<String>(
                items: distanceDropdownButtons(),
                value: getSelectedDistanceTypeString(),
                isExpanded: true,
                onChanged: (stringValue) => onDistanceDropdownChanged(stringValue , context)
            ),
          ),
        ],
      ),
    );
  }

  String getSelectedSportTypeString() => selectedSportTypeString;

  String getSelectedDistanceTypeString() => selectedDistanceTypeString;

  void onDistanceDropdownChanged(String? value , BuildContext context){
    if(value != null) {
      if(context.mounted) {
        setState(() {
          selectedDistanceTypeString = value;
          selectedDistanceType = LocationUtility.getDistanceSortTypeByString(selectedDistanceTypeString);
          context.read<CalendarQueryContainerBloc>().add(CalendarEventDistanceChangedEvent(selectedDistanceType));
        });
      }
    }
  }

  void onSportTypeChanged(String? value , BuildContext context){
    if(value != null){
      if(context.mounted) {
        setState(() {
          selectedSportTypeString = value;
          selectedSportEventType = SportEventUtils.getTypeBasedOnRandomTitle(selectedSportTypeString);
          context.read<CalendarQueryContainerBloc>().add(CalendarSportEventChangedEvent(selectedSportEventType));
        });
      }
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