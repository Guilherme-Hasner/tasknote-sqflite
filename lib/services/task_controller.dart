class TaskController {
  static String dateFormatFromSystem(String sqlDate, bool short) {
    String day = sqlDate.substring(8, 10);
    String month = sqlDate.substring(5, 7);
    String year = sqlDate.substring(0, 4);
    if (short) year = sqlDate.substring(2, 4);

    return "$day/$month/$year";
  }

  static String getHourFromSystem(String sqlDate) {
    return sqlDate.substring(11, 13);
  }

  static String getMinuteFromSystem(String sqlDate) {
    return sqlDate.substring(14, 16);
  }

  static String getTimeFromSystem(String sqlDate) {
    return "${sqlDate.substring(11, 13)}:${sqlDate.substring(14, 16)}";
  }

  static String dateTimeFromView(String date, String hour, String minute) {
    String year = date.substring(6, 10);
    String month = date.substring(3, 5);
    String day = date.substring(0, 2);

    return "$year-$month-$day $hour:$minute:00";
  }
}
