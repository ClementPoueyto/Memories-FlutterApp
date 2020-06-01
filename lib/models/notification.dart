import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memories/util/date_helper.dart';
import 'package:memories/view/my_material.dart';

class Notif {

  DocumentReference notifRef;
  String text;
  String date;
  String userId;
  DocumentReference ref;
  bool seen;
  String type;

  Notif(DocumentSnapshot snap) {
    notifRef = snap.reference;
    Map<String, dynamic> map = snap.data;
    text = map[keyTextNotification];
    date = DateHelper().myDate(map[keyDate].toDate());
    userId = map[keyUid];
    ref = map[keyRef];
    seen = map[keySeen];
    type = map[keyType];
  }

}