import 'package:flutter/material.dart';
import 'package:memories/models/notification.dart';
import 'package:memories/models/post.dart';
import 'package:memories/util/api_notif_helper.dart';
import 'package:memories/util/api_user_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/tiles/notif_tile.dart';

class NotificationPage extends StatefulWidget {
  final ValueNotifier<List<Post>> notifierPosts;
  final ValueNotifier<List<Notif>> notifierNotifs;

  NotificationPage(this.notifierPosts, this.notifierNotifs);
  NotificationState createState() => NotificationState();
}

class NotificationState extends State<NotificationPage> {
  List<String> usersId;
  Future<List<User>> users;

  @override
  void initState() {
    super.initState();
    refreshData();
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
          future:
          users,

          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              List<Notif> mynotifs = widget.notifierNotifs.value;
              List<User> users = snapshot.data;

              mynotifs.sort((a, b) => b.date.compareTo(a.date));

              return Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: mynotifs.length == 0 || users.length==0
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
                      height:
                      4 * MediaQuery
                          .of(context)
                          .size
                          .height / 5,
                      child: RefreshIndicator(
                        child: listBuilder(mynotifs, users),
                        onRefresh: () => refreshData(),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return  Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: feedNotifSave.length >0 && feedUserNotifSave.length>0
                    ? ListView(
                  addAutomaticKeepAlives: true,
                  children: <Widget>[
                    Container(
                      height:
                      4 * MediaQuery
                          .of(context)
                          .size
                          .height / 5,
                      child: RefreshIndicator(
                        child: listBuilder(feedNotifSave, feedUserNotifSave),
                        onRefresh: () => refreshData(),
                      ),
                    ),
                  ],
                )
                    :LoadingCenter()
              );
            }
          },
        ));
  }

  Widget listBuilder(List<Notif> mynotifs, List<User> users) {
    return ListView.builder(
        itemCount: mynotifs.length,
        itemBuilder:
            (BuildContext ctx, int index) {
          return Container(
            width: 100,
            height: 100,
            child: users
                .where((element) =>
            element.uid ==
                mynotifs[index]
                    .idFrom)
                .length >
                0
                ? NotifTile(
                mynotifs[index],
                users.firstWhere((element) =>
                element.uid ==
                    mynotifs[index].idFrom),
                widget.notifierPosts,
                widget.notifierNotifs)
                : SizedBox.shrink(),
          );
        });
  }

  Future<List<User>> fetchUsers(List<String> idList) async {
    List<User> users = List();
    if (idList.length > 0) {
      await Future.forEach(idList, (element) async {
        User user = await ApiUserHelper().getUserById(element);
        if (user != null) {
          users.add(user);
        }
      });
      return users;
    }
  }

  Future initUsers() {
    usersId = List();
    List<Notif> data = widget.notifierNotifs.value;
    if (data != null && data.length > 0) {
      data.sort((a, b) => b.date.compareTo(a.date));
      data.forEach((element) {
        if (!usersId.contains(element.idFrom)) {
          usersId.add(element.idFrom);
        }
      });
      users = fetchUsers(usersId);
      users.then((value) => feedUserNotifSave=value);
    }
    return users;
  }
  refreshData(){
    Future<List<Notif>> futureNotifs= ApiNotifHelper().getMyNotifs();
    futureNotifs.then((value) => {
      widget.notifierNotifs.value=value,
      initUsers(),
      widget.notifierNotifs.notifyListeners(),
    });
    return futureNotifs;
  }
}
