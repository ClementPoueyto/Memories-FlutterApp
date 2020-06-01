import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateHelper{

  String myDate(DateTime timestamp){
    initializeDateFormatting();

    DateFormat format;
    format = new DateFormat.yMMMd("fr_FR");

    return format.format(timestamp).toString();
  }

  bool isTheSameDay(DateTime date1, DateTime date2){
    if(date1.day==date2.day&&date1.month==date2.month&&date1.year==date2.year){
      return true;
    }
    return false;
  }

  bool isToday(DateTime date){
    DateTime today= DateTime.now();
    if(date.day==today.day&&date.year==today.year){
      return true;
    }
    else{
      return false;
    }
  }

}
