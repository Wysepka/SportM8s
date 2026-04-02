import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportm8s/calendar/container/calendar_date_range.dart';
import 'package:sportm8s/core/enums/enums_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeUtility{
  static String weekDayShortcut(CalendarWeekDay weekDay , BuildContext context){
    final l10n = AppLocalizations.of(context);
    switch(weekDay){
      case CalendarWeekDay.Invalid:
        return "Inv";
      case CalendarWeekDay.Monday:
        return l10n?.calendar_WeekDayMondayShortcut ?? "Mon";
      case CalendarWeekDay.Tuesday:
        return l10n?.calendar_WeekDayTuesdayShortcut ?? "Tue";
      case CalendarWeekDay.Wednesday:
        return l10n?.calendar_WeekDayWednesdayShortcut ?? "Wed";
      case CalendarWeekDay.Thursday:
        return l10n?.calendar_WeekDayThursdayShortcut ?? "Thu";
      case CalendarWeekDay.Friday:
        return l10n?.calendar_WeekDayFridayShortcut ?? "Fri";
      case CalendarWeekDay.Saturday:
        return l10n?.calendar_WeekDaySaturdayShortcut ?? "Sat";
      case CalendarWeekDay.Sunday:
        return l10n?.calendar_WeekDaySundayShortcut ?? "Sun";
    }
  }

  static String getRelativeDayLabel(DateTime date) {
    final DateTime now = DateTime.now();

    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime tomorrow = today.add(const Duration(days: 1));
    final DateTime target = DateTime(date.year, date.month, date.day);

    if (target == today) {
      return 'Today';
    }

    if (target == tomorrow) {
      return 'Tomorrow';
    }

    return '${target.day.toString().padLeft(2, '0')}.'
        '${target.month.toString().padLeft(2, '0')}.'
        '${target.year}';
  }

  static String formatHourMinute(DateTime dateTime) {
    final int hour = dateTime.hour;
    final int minute = dateTime.minute;

    final int hour12 = hour == 0
        ? 12
        : hour > 12
        ? hour - 12
        : hour;

    final String minuteString = minute.toString().padLeft(2, '0');
    final String period = hour >= 12 ? 'PM' : 'AM';

    return '$hour12:$minuteString $period';
  }

  static CalendarDateRange getCalendarDateRange(DateTime selectedDate){
    DateTime selectedDateTime = selectedDate;
    DateTimeRange monSunRange = TimeUtility.getWeekRange(selectedDate);
    List<int> dateDayRange = TimeUtility.getDateTimeDays(monSunRange.start , monSunRange.end);
    List<DateTime> weekDateTimeRange = getDaysInRange(monSunRange);

    return CalendarDateRange(selectedDateTime , monSunRange , dateDayRange , weekDateTimeRange);
  }

  static bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  static List<DateTime> getDaysInRange(DateTimeRange range) {
    final List<DateTime> days = [];

    DateTime current = DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
    );

    final DateTime end = DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
    );

    while (!current.isAfter(end)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  static List<int> getDateTimeDays(DateTime startDate, DateTime endDate){
    final List<int> days = [];

    DateTime current = DateTime(startDate.year, startDate.month, startDate.day);
    final DateTime end = DateTime(endDate.year, endDate.month, endDate.day);

    while (!current.isAfter(end)) {
      days.add(current.day);
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  static DateTimeRange getWeekRange(DateTime someDay) {
    final DateTime normalizedDay = DateTime(
      someDay.year,
      someDay.month,
      someDay.day,
    );

    final int daysFromMonday = normalizedDay.weekday - DateTime.monday;
    final DateTime startDate = normalizedDay.subtract(Duration(days: daysFromMonday));
    final DateTime endDate = startDate.add(const Duration(days: 6));

    return DateTimeRange(
      start: startDate,
      end: endDate,
    );
  }

  static CalendarWeekDay intToWeekDay(int weekDay){
    switch (weekDay) {
      case 0:
        return CalendarWeekDay.Monday;
      case 1:
        return CalendarWeekDay.Tuesday;
      case 2:
        return CalendarWeekDay.Wednesday;
      case 3:
        return CalendarWeekDay.Thursday;
      case 4:
        return CalendarWeekDay.Friday;
      case 5:
        return CalendarWeekDay.Saturday;
      case 6:
        return CalendarWeekDay.Sunday;
      default:
        return CalendarWeekDay.Invalid;
        throw ArgumentError('Invalid weekDay index: $weekDay. Expected value in range 0..6.');
    }
  }

  static CalendarWeekDay dateTimeToWeekDay(DateTime someDate) {
    switch (someDate.weekday) {
      case DateTime.monday:
        return CalendarWeekDay.Monday;
      case DateTime.tuesday:
        return CalendarWeekDay.Tuesday;
      case DateTime.wednesday:
        return CalendarWeekDay.Wednesday;
      case DateTime.thursday:
        return CalendarWeekDay.Thursday;
      case DateTime.friday:
        return CalendarWeekDay.Friday;
      case DateTime.saturday:
        return CalendarWeekDay.Saturday;
      case DateTime.sunday:
        return CalendarWeekDay.Sunday;
      default:
        return CalendarWeekDay.Invalid;
    }
  }

  static bool isDateInRangeByDay({
    required DateTimeRange range,
    required DateTime date,
  }) {
    final DateTime start = DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
    );

    final DateTime end = DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
    );

    final DateTime target = DateTime(
      date.year,
      date.month,
      date.day,
    );

    return !target.isBefore(start) && !target.isAfter(end);
  }
}