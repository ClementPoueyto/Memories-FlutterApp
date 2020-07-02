import 'package:memories/view/my_material.dart';

///Model notification

class Notif {

  String id;
  String text;
  DateTime date;
  String idFrom; //utilisateur qui envoie
  String idTo; //utilisateur qui recoit
  bool seen; // a été vue ?
  String type; // like, follow , comment ...
  String idRef;

  Notif(Map<String, dynamic> snap) {
    Map<String, dynamic> map = snap;
    id = map[keyId];
    text = map[keyTextNotification];
    date = DateTime.fromMillisecondsSinceEpoch(map[keyDate]);
    idFrom=map[keyIdFrom];
    idTo=map[keyIdTo];
    seen = map[keySeen];
    type = map[keyType];
    idRef = map['idRef'];
  }

}