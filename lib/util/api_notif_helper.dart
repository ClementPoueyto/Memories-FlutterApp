import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:memories/models/notification.dart';
import 'package:memories/view/my_material.dart';

/// Appel API Notification

class ApiNotifHelper {
  ///Renvoie les notifications de l'utilisateur connecté
  ///@required Token
  Future<List<Notif>> getMyNotifs() async {
    List<Notif> myNotifs = List();
    String errorMessage;

    try {
      final result = (await http.get(
        urlApi + "users/notifs/me",
        headers: {
          HttpHeaders.authorizationHeader: clientToken,
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8'
        },
      ));

      List<dynamic> notifs = jsonDecode(result.body);
      notifs.forEach((element) {
        myNotifs.add(Notif(element));
      });
      return myNotifs;
    } catch (error) {
      errorMessage = error.toString();
      print(errorMessage);
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  ///Modifie une notification, (update seen parameter)
  ///@required Token
  Future<Notif> updateNotif(String idNotif) async {
    Map<String, dynamic> notif;
    String errorMessage;
    try {
      final result = (await http.put(
        urlApi + "users/notifs/" + idNotif,
        headers: {
          HttpHeaders.authorizationHeader: clientToken,
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8'
        },
      ));
      notif = jsonDecode(result.body);
      return Notif(notif);
    } catch (error) {
      errorMessage = error.toString();
      print(errorMessage);
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }
}
