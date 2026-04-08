import 'package:flutter/material.dart';

class CalendarDateRange{
  DateTime selectedDateTime;
  DateTimeRange monSunRange;
  List<int> dateDayRange;
  List<DateTime> weekDateTime;

  CalendarDateRange(this.selectedDateTime , this.monSunRange , this.dateDayRange , this.weekDateTime);
  factory CalendarDateRange.createDummy(){
    return CalendarDateRange(DateTime.now(),DateTimeRange(start: DateTime.now(), end: DateTime.now()) ,[] ,[]);
  }
}