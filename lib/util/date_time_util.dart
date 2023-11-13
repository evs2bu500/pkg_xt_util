import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

const int msPerSecond = 1000;
const int msPerMinute = 60 * msPerSecond;
const int msPerHour = 60 * msPerMinute;
const int msPerDay = 24 * msPerHour;
const int msPerWeek = 7 * msPerDay;
const int msPerMonth = 30 * msPerDay;

DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

String getReadableDuration(Duration duration) {
  if (duration.inHours > 1) {
    if (duration.inHours < 72) {
      int hour = duration.inHours;
      return "$hour hour${hour > 1 ? "s" : ""}";
    } else if (duration.inDays < 8) {
      int day = duration.inDays;
      return "$day day${day > 1 ? "s" : ""}";
    } else if (duration.inDays < 63) {
      int week = duration.inDays ~/ 7;
      return "$week week${week > 1 ? "s" : ""}";
    } else if (duration.inDays < 365) {
      int month = duration.inDays ~/ 30;
      return "$month month${month > 1 ? "s" : ""}";
    } else {
      int year = duration.inDays ~/ 365;
      return "$year year${year > 1 ? "s" : ""}";
    }
  }
  return "${duration.inMinutes} min${duration.inMinutes > 1 ? "s" : ""}";
}

String? validateDatTimeStr(String dateTimeStr,
    {String format = "yyyy-MM-dd HH:mm:ss"}) {
  if ((format != "yyyy-MM-dd HH:mm:ss") &&
      (format != "yyyy-MM-dd HH:mm") &&
      (format != "yyyy-MM-dd")) {
    if (kDebugMode) {
      print("Validator: Unsupported DataTime format");
    }
    return 'Unsupported DataTime format';
  }
  int formatLength = format.length;
  int length = dateTimeStr.length;
  if (length != formatLength) {
    return 'Invalid date time format';
  }
  if (DateTime.tryParse(dateTimeStr) == null) {
    return 'Invalid date time format';
  }
  //check year
  int? year = int.tryParse(dateTimeStr.substring(0, 4));
  if (year != null) {
    if (year < 2020 || year > 2120) {
      return 'Invalid year';
    }
  }
  //check month
  int? month = int.tryParse(dateTimeStr.substring(5, 7));
  if (month != null) {
    if (month < 1 || month > 12) {
      return 'Invalid month';
    }
  }
  //check day
  int? day = int.tryParse(dateTimeStr.substring(8, 10));
  if (day != null) {
    if (day < 1 || day > 31) {
      return 'Invalid day';
    }
    //check that day is valid for the month
    if (day > 28) {
      if (month == 2) {
        if (day > 29) {
          return 'Invalid day for February';
        }
        if (day == 29 && year! % 4 != 0) {
          return 'Invalid day for February';
        }
      } else if (month == 4 || month == 6 || month == 9 || month == 11) {
        if (day > 30) {
          return 'Invalid day for this month';
        }
      }
    }
  }
  //check hour
  String hourStr =
      dateTimeStr.length >= 13 ? dateTimeStr.substring(11, 13) : '';
  int? hour = int.tryParse(hourStr);
  if (hour != null) {
    if (hour < 0 || hour > 23) {
      return 'Invalid hour';
    }
  }
  //check minute
  String minStr = dateTimeStr.length >= 16 ? dateTimeStr.substring(14, 16) : '';
  int? minute = int.tryParse(minStr);
  if (minute != null) {
    if (minute < 0 || minute > 59) {
      return 'Invalid minute';
    }
  }
  //check second
  String secondStr =
      dateTimeStr.length >= 19 ? dateTimeStr.substring(17, 19) : '';
  int? second = int.tryParse(secondStr);
  if (second != null) {
    if (second < 0 || second > 59) {
      return 'Invalid second';
    }
  }

  return null;
}

String getDateTimeStrFromTimestamp(int timestamp,
    {String format = "yyyy-MM-dd HH:mm:ss"}) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat(format).format(dateTime);
}

String getDateTimeStrFromDateTime(DateTime dateTime,
    {String format = "yyyy-MM-dd HH:mm:ss"}) {
  return DateFormat(format).format(dateTime);
}

String getDateFromDateTimeStr(String dateTimeStr,
    {String format = "yyyy-MM-dd"}) {
  DateTime dateTime = dateFormat.parse(dateTimeStr);
  return DateFormat(format).format(dateTime);
}

DateTime getSgNow() {
  return DateTime.now().toUtc().add(const Duration(hours: 8));
}

String getSgNowStr(String format) {
  return DateFormat(format).format(getSgNow());
}

//'target' stands for the brower/app timezone
//get target local datetime now
DateTime getTargetLocalDatetimeNow(int targetLocalTimezone) {
  int systemTimezone = DateTime.now().timeZoneOffset.inHours;
  return DateTime.now()
      .toLocal()
      .add(Duration(hours: targetLocalTimezone - systemTimezone));
}

// get target local datetime in hour, minute, second,
// example: getTargetLocalDatetime(8, 12, 0, 0) will return 12:00:00 in Singapore time
DateTime getTargetLocalDatetime(
    int targetLocalTimezone, int hour, int minute, int second, int milli,
    {DateTime? refLocalDatetime}) {
  DateTime targetLocalDatetime;
  if (refLocalDatetime != null) {
    targetLocalDatetime = refLocalDatetime;
  } else {
    // Calculate the timezone offset in hours
    Duration timezoneOffset = Duration(hours: targetLocalTimezone);

    // Get the current UTC time
    DateTime currentUtcTime = DateTime.now().toUtc();
    // if (refDatetime != null) {
    //   currentUtcTime = refDatetime.toUtc();
    // }

    // Apply the timezone offset to the current UTC time
    targetLocalDatetime = currentUtcTime.add(timezoneOffset);
  }

  // Set the time components
  targetLocalDatetime = DateTime(
      targetLocalDatetime.year,
      targetLocalDatetime.month,
      targetLocalDatetime.day,
      hour,
      minute,
      second,
      milli,
      0);

  return targetLocalDatetime;
}

String getLocalDatetimeNowStr(int timezone,
    {String? format = "yyyy-MM-dd HH:mm:ss"}) {
  String xformat = format ?? "yyyy-MM-dd HH:mm:ss";
  return DateFormat(xformat)
      .format(DateTime.now().toUtc().add(Duration(hours: timezone)));
}

DateTime getTargetDatetime(int targetTimestamp) {
  return DateTime.fromMillisecondsSinceEpoch(targetTimestamp);
}

DateTime getTargetDatetimeFromTargetStr(String targetDateTimeStr) {
  DateTime targetDateTime = DateTime.parse(targetDateTimeStr);

  return targetDateTime;
}

String getLocalDatetimeStr(DateTime datetime, int timezone,
    {String? format = "yyyy-MM-dd HH:mm:ss"}) {
  String xformat = format ?? "yyyy-MM-dd HH:mm:ss";
  return DateFormat(xformat).format(
      DateTime.fromMillisecondsSinceEpoch(datetime.millisecondsSinceEpoch)
          .toUtc()
          .add(Duration(hours: timezone)));
}
