import 'package:flutter/material.dart';
import 'package:memories/controller/detail_post_controller.dart';
import 'package:memories/controller/user_controller.dart';
import 'package:memories/models/notification.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/api_notif_helper.dart';
import 'package:memories/util/api_post_helper.dart';
import 'package:memories/util/date_helper.dart';
import 'package:memories/view/my_material.dart';

class NotifTile extends StatelessWidget {
  final Notif notif;
  final User user;
  final ValueNotifier<List<Post>> notifierPosts;
  final ValueNotifier<List<Notif>> notifierNotifs;

  NotifTile(this.notif, this.user,this.notifierPosts,this.notifierNotifs);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        ApiNotifHelper().updateNotif(notif.id).then((updatedNotif) => {
          notify(updatedNotif)
        });
        if (notif.type == 'follow' ) {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext build) {
            return UserController(user,this.notifierPosts);
          }));
        } else {
          Future<Post> post = ApiPostHelper().getPostById(notif.idRef);
          post.then((value) => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ctx) {
                  return DetailPost(value, me,this.notifierPosts);
                }))
              });
        }
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
        child: Card(
          elevation: 5.0,
          color: (!notif.seen) ? Colors.grey[400] : whiteShadow,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ProfileImage(
                  urlString: user.imageUrl,
                  onPressed: null,
                ),
                Flexible(
                  child: PaddingWith(
                    left: 10,
                    right: 10,
                    widget: MyText(
                      notif.text,
                      color: black,
                      fontSize: 14,
                    ),
                  ),
                ),
                Flexible(
                    child: MyText(
                  DateHelper().myDate(notif.date),
                  color: black,
                  fontSize: 12,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  notify(Notif notif){
    this.notifierNotifs.value.firstWhere((element) => element.id==notif.id).seen=true;
    notifierNotifs.notifyListeners();
  }
}
