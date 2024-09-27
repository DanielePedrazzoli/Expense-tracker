class MonthHelper {
  MonthHelper();

  static const months = [
    'Gennaio',
    'Febbraio',
    'Marzo',
    'Aprile',
    'Maggio',
    'Giugno',
    'Luglio',
    'Agosto',
    'Settembre',
    'Ottobre',
    'Novembre',
    'Dicembre'
  ];

  /// Return month name in italian based on the index
  /// - 1 --> Gennaio
  /// - 2 --> Febbraio
  /// - ...
  /// - 12 --> Dicembre
  static String getMonthName(int month) {
    return months[month - 1];
  }

  /// Return month length based on the index
  /// - 1 --> 31
  /// - 2 --> 28
  /// ...
  /// - 12 --> 31
  ///
  /// If year is provided, it will return the month length for that
  /// year considering the leap year
  static int returnMonthLenght(int month, [int? year]) {
    if (month == 2 && year != null && isLeapYear(year)) {
      return 29;
    }

    if (month == 2) {
      return 28;
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
      return 30;
    } else {
      return 31;
    }
  }

  /// Return if the year passed is a leap year
  static bool isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  static retriveMonthIndex(String month) {
    return months.indexOf(month) + 1;
  }
}
