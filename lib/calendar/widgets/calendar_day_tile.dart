import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:sportm8s/core/utility/time_utility.dart';

class CalendarDayTile extends StatefulWidget{
  final CalendarWeekDay weekDay;
  final int monthDayID;
  final bool hasEventsThisDay;

  final Function(CalendarDayTile) dateTimeSelectedFunction;


  const CalendarDayTile({super.key , required this.weekDay , required this.monthDayID , required this.hasEventsThisDay ,required this.dateTimeSelectedFunction});

  //CalendarDayTile({super.key ,required this.weekDay , required this.monthID});

  @override
  State<StatefulWidget> createState() => _CalendarDayTile();
}

class _CalendarDayTile extends State<CalendarDayTile>{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.dateTimeSelectedFunction(widget),
      child: InkWell(
        child: Column(
          children: [
            SizedBox(height: 6,),
            Text(TimeUtility.weekDayShortcut(widget.weekDay, context) , style: Theme.of(context).textTheme.labelMedium,),
            SizedBox(height: 4,),
            Text(widget.monthDayID.toString() , style: Theme.of(context).textTheme.labelLarge,),
            SizedBox(height: 4,),
            if(widget.hasEventsThisDay)...{
              Icon(Icons.circle),
              SizedBox(height: 4,),
            }
          ],
        ),
      ),
    );
  }
}