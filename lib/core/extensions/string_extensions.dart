import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime{
  String toDate() => DateFormat('dd.MM.yy').format(this);
  String toDate24() => DateFormat('dd.MM.yy HH.mm').format(this);
}

extension TimeOfDayFormatting on TimeOfDay{
  String to24h() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

}