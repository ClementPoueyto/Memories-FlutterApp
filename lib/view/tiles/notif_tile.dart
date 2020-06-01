import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/controller/detail_post_controller.dart';
import 'package:memories/models/notification.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/page/profile_page.dart';


class NotifTile extends StatelessWidget {

  Notif notif;

  NotifTile(this.notif);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<DocumentSnapshot>(
      stream: FireHelper().fire_user.document(notif.userId).snapshots(),
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snap) {
        if (!snap.hasData) {
          return Container();
        } else {
          User user = User(snap.data);
          return InkWell(
            onTap: () {
              notif.notifRef.updateData({keySeen: true});
              if (notif.type == keyFollowers) {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext build) {
                  return Scaffold(body: SafeArea(child: ProfilePage(user)));
                }));
              } else {
                notif.ref.get().then((snap) {
                  Post post = Post(snap);
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx) {
                    return DetailPost(post, user);
                  }));
                });
              }

            },
            child: Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
              child: Card(
                elevation: 5.0,
                color: (!notif.seen)? white: Colors.red,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ProfileImage(urlString: user.imageUrl, onPressed: null,),
                          Text(notif.date, )
                        ],
                      ),
                      Text(notif.text,)
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

}