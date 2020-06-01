import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/models/notification.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/tiles/notif_tile.dart';


class NotificationPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      stream: FireHelper().fire_user.document(me.uid).collection("notifications").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snaps) {
        if (!snaps.hasData) {
          return Center(child: Text("Aucune notification"));
        } else {
          //Créer notifs
          List<DocumentSnapshot> documents = snaps.data.documents;
          return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (BuildContext ctx, int index) {
                Notif notif = Notif(documents[index]);
                return NotifTile(notif);
              });
        }
      },
    );
  }
}