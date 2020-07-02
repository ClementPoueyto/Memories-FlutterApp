import 'package:flutter/material.dart';
import 'package:memories/models/notification.dart';
import 'package:memories/util/api_notif_helper.dart';
import 'package:memories/util/api_user_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/tiles/notif_tile.dart';

class NotificationPage extends StatefulWidget {
  NotificationState createState() => NotificationState();
}

class NotificationState extends State<NotificationPage> {
  Future<List<Notif>> notifs;
  List<String> usersId;
  Future<List<User>> users;

  @override
  void initState() {
    super.initState();
    initPage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          "Mes notifications",
          fontSize: 20,
        ),
      ),
      body: FutureBuilder(
        future: Future.wait([
          notifs,
          users,
        ]),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            List<Notif> mynotifs = snapshot.data[0];
            mynotifs.sort((a, b) => b.date.compareTo(a.date));
            List<User> users = snapshot.data[1];

            return Container(
              height: MediaQuery.of(context).size.height,
              child: mynotifs.length == 0
                  ? Center(
                      child: MyText(
                        "Aucune notification",
                        color: black,
                        fontSize: 18,
                      ),
                    )
                  : ListView(
                      addAutomaticKeepAlives: true,
                      children: <Widget>[
                        Container(
                          height: 4 * MediaQuery.of(context).size.height / 5,
                          child: RefreshIndicator(
                            child: ListView.builder(
                                itemCount: mynotifs.length,
                                itemBuilder: (BuildContext ctx, int index) {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    child: users
                                                .where((element) =>
                                                    element.uid ==
                                                    mynotifs[index].idFrom)
                                                .length >
                                            0
                                        ? NotifTile(
                                            mynotifs[index],
                                            users.firstWhere((element) =>
                                                element.uid ==
                                                mynotifs[index].idFrom),
                                            refresh)
                                        : SizedBox.shrink(),
                                  );
                                }),
                            onRefresh: () => initPage(),
                          ),
                        ),
                      ],
                    ),
            );
          } else {
            if (notifsList.length != null && userNotif.length != null) {
              return userNotif.length>0?ListView(addAutomaticKeepAlives: true, children: <Widget>[
                Container(
                  height: 4 * MediaQuery.of(context).size.height / 5,
                  child: RefreshIndicator(
                    child: ListView.builder(
                        itemCount: notifsList.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return Container(
                            width: 100,
                            height: 100,
                            child: userNotif
                                        .where((element) =>
                                            element.uid ==
                                            notifsList[index].idFrom)
                                        .length >
                                    0
                                ? NotifTile(
                                    notifsList[index],
                                    userNotif.firstWhere((element) =>
                                        element.uid ==
                                        notifsList[index].idFrom),
                                    refresh)
                                : SizedBox.shrink(),
                          );
                        }),
                    onRefresh: () => initPage(),
                  ),
                ),
              ]):Center(
                child: MyText(
                  "Aucune notification",
                  color: black,
                  fontSize: 18,
                ),
              );
            } else {
              return LoadingCenter();
            }
          }
        },
      ),
    );
  }

  Future<List<User>> loadUsers(List<String> idList) async {
    List<User> users = List();
    if (idList.length > 0) {
      await Future.forEach(idList, (element) async {
        User user = await ApiUserHelper().getUserById(element);
        if (user != null) {
          users.add(user);
        }
      });
      userNotif = users;
      return users;
    }
  }

  Future initPage() {
    usersId = List();
    notifs = ApiNotifHelper().getMyNotifs();
    notifs.then((data) => {
          if (data != null && data.length > 0)
            {
              data.sort((a, b) => b.date.compareTo(a.date)),
              notifsController.add(data),
              notifsList = data,
              data.forEach((element) {
                if (!usersId.contains(element.idFrom)) {
                  usersId.add(element.idFrom);
                }
              }),
              users = loadUsers(usersId)
            }
        });
    setState(() {});
    return notifs;
  }

  refresh() {
    initPage();
    setState(() {});
  }
}
