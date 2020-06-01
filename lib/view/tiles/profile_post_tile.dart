import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memories/delegate/header_delegate.dart';
import 'package:memories/models/user.dart';
import 'package:memories/models/post.dart';

class ProfilePostTile extends StatelessWidget{

  final Post post;
  final User user;
  final bool detail;

  ProfilePostTile({@required Post this.post, @required User this.user, bool this.detail : false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all( 5.0),
      child: Card(
          child :Column(children: <Widget>[


            Image(
                height:90 ,
                image: CachedNetworkImageProvider(post.imageUrl,)
            ),
            Text(post.date.day.toString())
          ],)
      )
    );
  }
}