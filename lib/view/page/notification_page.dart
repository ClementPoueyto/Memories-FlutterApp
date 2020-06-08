import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/models/notification.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/tiles/notif_tile.dart';

class NotificationPage extends StatefulWidget {
  NotificationState createState() => NotificationState();
}

class NotificationState extends State<NotificationPage> {
  List<Notif> sortedNotif;
  List<String> usersId;
  List<User> usersNotif;
  @override
  void initState() {
    super.initState();
    sortedNotif = List();
    usersId=List();
    usersNotif = List();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: MyText(
            "Mes notifications",
            fontSize: 20,
          ),
        ),
        body: ListView(
          addAutomaticKeepAlives: true,
          children: <Widget>[
            SizedBox(
              height: 4 * MediaQuery.of(context).size.height / 5,
              child: StreamBuilder<QuerySnapshot>(
                stream: FireHelper()
                    .fire_user
                    .document(me.uid)
                    .collection("notifications").orderBy(keyDate, descending: true).limit(20)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snaps) {
                  if (!snaps.hasData) {
                    return LoadingCenter();
                  } else {
                    //Créer notifs
                    List<DocumentSnapshot> documents = snaps.data.documents;
                    if (documents.length == 0) {
                      return Center(
                        child: MyText(
                          "Aucune notification",
                          color: black,
                          fontSize: 25,
                        ),
                      );
                    }
                    sortedNotif = [];
                    documents.forEach((element) {
                      Notif myNotif = Notif(element);
                      sortedNotif.add(myNotif);
                      if(!usersId.contains(myNotif.userId)){
                        usersId.add(myNotif.userId);
                      }
                    });
                    sortedNotif.sort((a, b) => b.time.compareTo(a.time));

                    return StreamBuilder(
                        stream: FireHelper()
                            .fire_user
                            .where(keyUid, whereIn: usersId).snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snaps) {
                          if (!snaps.hasData) {
                            return LoadingCenter();
                          } else {
                            //Créer notifs
                            List<DocumentSnapshot> usersDocs = snaps.data.documents;
                            usersDocs.forEach((userDoc) { 
                              usersNotif.add(User(userDoc));
                            });
                            if (documents.length == 0) {
                              return Center(
                                child: MyText(
                                  "Aucune notification",
                                  color: black,
                                  fontSize: 25,
                                ),
                              );
                            } else {
                              return ListView.builder(
                                  controller: ScrollController(),
                                  itemCount: sortedNotif.length,
                                  itemBuilder: (BuildContext ctx, int index) {
                                    return NotifTile(sortedNotif[index],usersNotif.firstWhere((element) => element.uid==sortedNotif[index].userId));
                                  });
                            }
                          }
                        });
                  }
                },
              ),
            ),
          ],
        ));
  }
}
