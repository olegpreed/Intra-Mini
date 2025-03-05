import 'package:forty_two_planet/utils/class_utils.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

String timeAgoShort(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays >= 365) {
    final years = (difference.inDays / 365).floor();
    return '$years${years > 1 ? 'Y' : 'Y'}';
  }

  if (difference.inDays >= 30) {
    final months = (difference.inDays / 30).floor();
    return '$months${months > 1 ? 'M' : 'M'}';
  }

  if (difference.inDays >= 1) {
    return '${difference.inDays}d';
  }

  if (difference.inHours >= 1) {
    return '${difference.inHours}h';
  }

  if (difference.inMinutes >= 1) {
    return '${difference.inMinutes}m';
  }

  return 'Just now';
}

String timeAgoDetailed(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  String result = '';

  if (difference.inDays >= 365) {
    final years = (difference.inDays / 365).floor();
    result = '$years ${years == 1 ? 'year' : 'years'} ago';
  } else if (difference.inDays >= 30) {
    final months = (difference.inDays / 30).floor();
    result = '$months ${months == 1 ? 'month' : 'months'} ago';
  } else if (difference.inDays >= 1) {
    result =
        '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
  } else if (difference.inHours >= 1) {
    result =
        '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
  } else if (difference.inMinutes >= 1) {
    result =
        '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
  } else {
    result = 'Just now';
  }

  return result;
}

DateTime roundUpTo15Minutes(DateTime dateTime) {
  int minute = dateTime.minute;
  int remainder = minute % 15;

  if (remainder == 0) {
    // If the time is already on a 15-minute mark, return the original time
    return dateTime;
  }

  // Calculate the difference needed to round up to the nearest 15 minutes
  int adjustment = 15 - remainder;

  // Add the adjustment to the current time
  return dateTime.add(Duration(minutes: adjustment));
}

String formatMinutes(int totalMinutes) {
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;

  // Format the hours and minutes as h:mm
  return '$hours:${minutes.toString().padLeft(2, '0')}';
}

DateTime getFirstDayOfWeek(DateTime date) {
  final int daysToSubtract = date.weekday % 7;
  return date.subtract(Duration(days: daysToSubtract));
}

DateTime getLastDayOfWeek(DateTime date) {
  final int daysToAdd = (6 - date.weekday + 7) % 7;
  return date.add(Duration(days: daysToAdd));
}

Future<Map<DateTime, List<Pair<Duration, Duration>>>> convertLogData(
    String jsonResponse) async {
  final Map<String, dynamic> data = json.decode(jsonResponse);

  final DateTime now = DateTime.now();
  final List<DateTime> months = List.generate(4, (i) {
    final DateTime firstDayOfMonth = DateTime(now.year, now.month - 3 + i, 1);
    return firstDayOfMonth;
  }).reversed.toList();
  final Map<DateTime, List<Pair<Duration, Duration>>> result = {
    for (final month in months) month: calculateWeekLogs(month, data),
  };

  return result;
}

List<Pair<Duration, Duration>> calculateWeekLogs(
    DateTime startDate, Map<String, dynamic> data) {
  final List<Pair<Duration, Duration>> weekLogs = [];
  DateTime endDate = DateTime(startDate.year, startDate.month + 1, 0);
  for (DateTime date = getFirstDayOfWeek(startDate);
      date.isBefore(getLastDayOfWeek(endDate).add(const Duration(days: 1)));
      date = date.add(const Duration(days: 1))) {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    if (date.weekday == 7) {
      Duration time = data[formattedDate] != null
          ? _parseTimeToDuration(data[formattedDate])
          : Duration.zero;
      if (startDate.month != date.month) {
        weekLogs.add(Pair(Duration.zero, time));
      } else {
        weekLogs.add(Pair(time, Duration.zero));
      }
    } else {
      if (startDate.month != date.month) {
        weekLogs[weekLogs.length - 1].second += data[formattedDate] != null
            ? _parseTimeToDuration(data[formattedDate])
            : Duration.zero;
      } else {
        weekLogs[weekLogs.length - 1].first += data[formattedDate] != null
            ? _parseTimeToDuration(data[formattedDate])
            : Duration.zero;
      }
    }
  }
  return weekLogs;
}

Duration _parseTimeToDuration(String time) {
  final timeParts = time.split(":");
  final int hours = int.parse(timeParts[0]);
  final int minutes = int.parse(timeParts[1]);
  final int seconds = double.parse(timeParts[2]).toInt();
  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

Duration calcAverageTime(
    List<Pair<Duration, Duration>> monthLogtime, DateTime month) {
  Duration totalLogtime = Duration.zero;
  DateTime now = DateTime.now();
  for (final Pair<Duration, Duration> week in monthLogtime) {
    totalLogtime += week.first;
  }
  int daysPassed = 0;
  if (month.month == now.month && month.year == now.year) {
    daysPassed = now.day;
  }
  else {
    daysPassed = DateTime(month.year, month.month + 1, 0).day;
  }
  return totalLogtime ~/ daysPassed;
}

int getWeekNumber(DateTime date) {
  DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
  int firstWeekday = firstDayOfMonth.weekday % 7;
  int daysOffset = date.day + firstWeekday - 1; 
  return (daysOffset ~/ 7) + 1;
}
