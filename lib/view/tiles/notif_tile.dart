import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/controller/detail_post_controller.dart';
import 'package:memories/controller/user_controller.dart';
import 'package:memories/models/notification.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/page/profile_page.dart';


class NotifTile extends StatelessWidget {

  Notif notif;
  User user;

  NotifTile(this.notif,this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
          return InkWell(
            onTap: () {
              notif.notifRef.updateData({keySeen: true});
              if (notif.type == keyFollowers) {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext build) {
                  return UserController(user);
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
                color: (!notif.seen)? Colors.grey[400]: whiteShadow,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                      child :Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ProfileImage(urlString: user.imageUrl, onPressed: null,),
                          Flexible(child :PaddingWith(
                            left: 10,
                            right: 10,
                            widget :Text(notif.text,),),),
                          Flexible(child :Text(notif.date, )),
                        ],
                      ),

                ),
              ),
            ),
          );
        }

}