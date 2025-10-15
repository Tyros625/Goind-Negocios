import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class DateConverterHelper {

  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime).toLocal();
  }

  static String dateTimeStringToDateTime(String dateTime) {
    return DateFormat('dd MMM yyyy  ${_timeFormatter()}').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static String dateTimeStringToDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static DateTime dateTimeStringToDate(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateTimeOnly(String dateTime) {
    return DateFormat('dd MMM yyyy | HH:mm a').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime);
  }

  static String convertStringTimeToTime(String time) {
    return DateFormat(_timeFormatter()).format(DateFormat('HH:mm').parse(time));
  }

  static String convertTimeToTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static DateTime convertTimeToDateTime(String time) {
    return DateFormat('HH:mm').parse(time);
  }

  static String convertDateToDate(String date) {
    return DateFormat('dd MMM yyyy').format(DateFormat('yyyy-MM-dd').parse(date));
  }

  static String dateTimeStringToMonthAndTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return 'N/A';
    try {
      return DateFormat('dd MMM yyyy HH:mm a').format(dateTimeStringToDate(dateTime));
    } catch (e) {
      return 'Invalid date';
    }
  }

  static String dateTimeForCoupon(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static String utcToDateTime(String dateTime) {
    return DateFormat('dd MMM, yyyy h:mm a').format(DateTime.parse(dateTime).toLocal());
  }

  static String utcToDate(String dateTime) {
    return DateFormat('dd MMM, yyyy').format(DateTime.parse(dateTime));
  }

  static bool isAvailable(String? start, String? end, {DateTime? time, bool isoTime = false}) {
    DateTime currentTime;
    if(time != null) {
      currentTime = time;
    }else {
      currentTime = Get.find<SplashController>().currentTime;
    }
    DateTime start0 = start != null ? isoTime ? isoStringToLocalDate(start) : DateFormat('HH:mm').parse(start) : DateTime(currentTime.year);
    DateTime end0 = end != null ? isoTime ? isoStringToLocalDate(end) : DateFormat('HH:mm').parse(end) : DateTime(currentTime.year, currentTime.month, currentTime.day, 23, 59);
    DateTime startTime = DateTime(currentTime.year, currentTime.month, currentTime.day, start0.hour, start0.minute, start0.second);
    DateTime endTime = DateTime(currentTime.year, currentTime.month, currentTime.day, end0.hour, end0.minute, end0.second);
    if(endTime.isBefore(startTime)) {
      endTime = endTime.add(const Duration(days: 1));
    }
    return currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
  }

  static String _timeFormatter() {
    return Get.find<SplashController>().configModel!.timeformat == '24' ? 'HH:mm' : 'hh:mm a';
  }

  static String localDateToIsoStringAMPM(DateTime dateTime) {
    return DateFormat('${_timeFormatter()} | d-MMM-yyyy ').format(dateTime.toLocal());
  }

  static String dateTimeStringForDisbursement(String time) {
    var newTime = '${time.substring(0,10)} ${time.substring(11,23)}';
    return DateFormat('dd MMM, yyyy').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(newTime));
  }

  // static int expireDifferanceInDays(DateTime dateTime) {
  //   return dateTime.difference(DateTime.now()).inDays;
  // }

  static String localDateToMonthDateSince(DateTime dateTime) {
    return DateFormat('MMM d, yyyy ').format(dateTime.toLocal());
  }

  static int differenceInDaysIgnoringTime(DateTime dateTime1, DateTime? dateTime2) {
    DateTime date1 = DateTime(dateTime1.year, dateTime1.month, dateTime1.day);
    DateTime date2;
    if(dateTime2 != null) {
      date2 = DateTime(dateTime2.year, dateTime2.month, dateTime2.day);
    } else {
      date2 = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    }
    return date1.difference(date2).inDays;
  }

  static String stringToMDY(String dateTime) {
    return DateFormat('MM/dd/yyyy').format(DateTime.parse(dateTime).toLocal());
  }

  static DateTime stringToDateTimeMDY(String dateTime) {
    return DateFormat('MM/dd/yyyy').parse(dateTime).toLocal();
  }

  static DateTime isoUtcStringToLocalDateOnly(String dateTime) {
    return DateFormat('yyyy-MM-dd').parse(dateTime, true).toLocal();
  }

  static String dateMonthYearTime(DateTime ? dateTime) {
    return DateFormat('d MMM, y ${_timeFormatter()}').format(dateTime!);
  }

  static DateTime isoUtcStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime, true).toLocal();
  }

  static String stringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM, yyyy').format(DateTime.parse(dateTime).toLocal());
  }

  static String dayDateTime(String dateTime) {
    return DateFormat('EEEE, dd MMMM yyyy, hh:mm a').format(DateTime.parse(dateTime).toLocal());
  }

  static DateTime formattingTripDateTime(DateTime pickedTime, DateTime pickedDate) {
    return DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
  }

  static bool isSameDate(DateTime pickedTime) {
    return pickedTime.year == DateTime.now().year && pickedTime.month == DateTime.now().month && pickedTime.day == DateTime.now().day && pickedTime.hour == DateTime.now().hour;
  }

  static bool isAfterCurrentDateTime(DateTime pickedTime) {
    DateTime pick = DateTime(pickedTime.year, pickedTime.month, pickedTime.day, pickedTime.hour, pickedTime.minute);
    DateTime current = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
    return pick.isAfter(current);
  }

  static String dateTimeForTax(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }



}