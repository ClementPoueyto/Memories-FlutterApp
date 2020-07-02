import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:memories/view/my_material.dart';

///Permet de manipuler les dates à partir d'un Timestamp ou DateTime
class DateHelper {
  ///Renvoie day month
  String myDate(DateTime timestamp) {
    initializeDateFormatting();

    DateFormat format;
    format = new DateFormat.yMMMd("fr_FR");

    return format.format(timestamp).toString();
  }

  ///verifie si les deux dates proviennent du meme jour
  bool isTheSameDay(DateTime date1, DateTime date2) {
    if (date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year) {
      return true;
    }
    return false;
  }

  ///Verifie si la date est d'aujourd'hui
  bool isToday(DateTime date) {
    DateTime today = DateTime.now();
    if (date.day == today.day && date.year == today.year) {
      return true;
    } else {
      return false;
    }
  }

  ///non utilisé
  String differenceDate(DateTime date) {
    DateTime today = DateTime.now();
    Duration dif = today.difference(date);
    return dif.toString();
  }

  /// enumeration des mois de l'année
  String getValue(Months months) {
    switch (months) {
      case Months.january:
        return "Janvier";
      case Months.february:
        return "Février";
      case Months.march:
        return "Mars";
      case Months.april:
        return "Avril";
      case Months.may:
        return "Mai";
      case Months.june:
        return "Juin";
      case Months.july:
        return "Juillet";
      case Months.august:
        return "Aout";
      case Months.september:
        return "Septembre";
      case Months.october:
        return "Octobre";
      case Months.november:
        return "Novembre";
      case Months.december:
        return "Décembre";
      default:
        return "";
    }
  }

  ///enumeration des jours de la semaine
  String getWeekDay(int day) {
    switch (day) {
      case 1:
        return "Lundi";
      case 2:
        return "Mardi";
      case 3:
        return "Mercredi";
      case 4:
        return "Jeudi";
      case 5:
        return "Vendredi";
      case 6:
        return "Samedi";
      case 7:
        return "Dimanche";
      default:
        return "";
    }
  }

  ///Renvoie min : h
  String getTime(DateTime date) {
    String res = "";
    res += date.hour.toString().length > 1
        ? date.hour.toString()
        : "0" + date.hour.toString();
    res += " : ";
    res += date.minute.toString().length > 1
        ? date.minute.toString()
        : "0" + date.minute.toString();
    return res;
  }
}
