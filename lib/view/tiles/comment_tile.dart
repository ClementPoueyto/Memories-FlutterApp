import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/models/comment.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';

class CommentTile extends StatelessWidget {

  Comment comment;

  CommentTile(this.comment);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FireHelper().fire_user.document(comment.userId).snapshots(),
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snap) {
        if (snap.hasData) {
          User user = User(snap.data);
          return Container(

            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 0.6), //(x,y)
                  blurRadius: 1.0,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(25)),
              border: Border.all(
                color: whiteShadow,
              ),
              color: white,
            ),
            margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 2.5),
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ProfileImage(urlString: user.imageUrl, onPressed: null, size: 15.0,),
                        PaddingWith(
                          left: 10,
                          right: 10,
                          bottom: 0,
                          top: 0,
                          widget:Text("${user.firstName} ${user.lastName}"),),
                      ],
                    ),
                    Text(comment.date,)
                  ],
                ),
                Text(comment.textComment, )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

}