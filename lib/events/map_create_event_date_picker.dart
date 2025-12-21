
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/core/extensions/string_extensions.dart';
import 'package:sportm8s/events/map_event_widget_container.dart';

class MapCreateEventDatePicker extends StatefulWidget{
  final Function(DateTime) dateTimeSelectedFunction;
  final DateTime? defaultEventDate;
  final Function(TimeOfDay) timeOfDaySelectedFunction;
  final TimeOfDay? defaultEventTime;

  const MapCreateEventDatePicker(this.dateTimeSelectedFunction, this.defaultEventDate , this.timeOfDaySelectedFunction, this.defaultEventTime, {super.key});

  @override
  State<StatefulWidget> createState() => _MapCreateEventDatePicker();
}

class _MapCreateEventDatePicker extends State<MapCreateEventDatePicker>{

  DateTime? selectedEventDate;
  TimeOfDay? selectedEventTime;
  
  @override
  Widget build(BuildContext context) {
    if(widget.defaultEventDate != null){
      selectedEventDate = widget.defaultEventDate;
    }

    if(widget.defaultEventTime != null){
      selectedEventTime = widget.defaultEventTime;
    }

    return MapEventWidgetContainer(
      child: Column(
        children: [
          Container(
              child: Text(
                selectedEventDate != null ? selectedEventDate!.toDate() : "" ,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              )
          ),
          ElevatedButton(
              onPressed: _showDatePicker,
              child: Text("Select Date")
          ),
          if(selectedEventDate != null)...
          [
              Text(
                selectedEventTime != null ? selectedEventTime!.to24h() : "",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              ElevatedButton(
                onPressed: _showTimePicker,
                child: Text("Select Time")
              )
          ],
        ]
      ),
    );
  }

  void _showDatePicker() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)));

    if(date != null) {
      setState(() {
        selectedEventDate = date;
        widget.dateTimeSelectedFunction(selectedEventDate!);
      });
    }
  }

  void _showTimePicker() async {
    final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
    );

    if(time != null) {
      setState(() {
        selectedEventTime = time;
        widget.timeOfDaySelectedFunction(selectedEventTime!);
      });
    }
  }

}