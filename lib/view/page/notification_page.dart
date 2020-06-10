import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/models/notification.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/tiles/notif_tile.dart';

class NotificationPage extends StatefulWidget {
  List<DocumentSnapshot> myNotifs;
  NotificationPage(this.myNotifs);
  NotificationState createState() => NotificationState();
}

class NotificationState extends State<NotificationPage> {
  List<Notif> sortedNotif;
  List<String> usersId;
  List<User> usersNotif;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sortedNotif = List();
    usersId = List();
    usersNotif = List();
    widget.myNotifs.forEach((element) {
      Notif myNotif = Notif(element);
      sortedNotif.add(myNotif);
      if (!usersId.contains(myNotif.userId)) {
        usersId.add(myNotif.userId);
      }
    });
    sortedNotif.sort((a, b) => b.time.compareTo(a.time));
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          "Mes notifications",
          fontSize: 20,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          addAutomaticKeepAlives: true,
          children: <Widget>[
            Container(
              height: 4 * MediaQuery.of(context).size.height / 5,
              child: ListView.builder(
                itemCount: sortedNotif.length,
                itemBuilder: (BuildContext ctx, int index) {
                  if (sortedNotif.length == 0) {
                    return Center(
                      child: MyText(
                        "Aucune notification",
                        color: black,
                        fontSize: 25,
                      ),
                    );
                  } else {
                    return StreamBuilder(
                      stream: FireHelper()
                          .fire_user
                          .where(keyUid, whereIn: usersId)
                          .snapshots(),
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
                          if (usersDocs.length == 0) {
                            return Center(
                              child: MyText(
                                "Aucune notification",
                                color: black,
                                fontSize: 25,
                              ),
                            );
                          } else {
                            return Container(
                              width: 100,
                              height: 100,
                              child: usersNotif
                                          .where((element) => element.uid == sortedNotif[index].userId)
                                          .length > 0
                                  ? NotifTile(
                                      sortedNotif[index],
                                      usersNotif.firstWhere((element) =>
                                          element.uid ==
                                          sortedNotif[index].userId))
                                  : SizedBox.shrink(),
                            );
                          }
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
