import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memories/controller/detail_post_controller.dart';
import 'package:memories/delegate/header_delegate.dart';
import 'package:memories/models/user.dart';
import 'package:memories/models/post.dart';
import 'package:memories/util/date_helper.dart';
import 'package:memories/view/my_material.dart';

class ProfilePostTile extends StatelessWidget {
  final Post post;
  final User user;
  final bool detail;

  ProfilePostTile(
      {@required Post this.post,
      @required User this.user,
      bool this.detail: false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailPost(post, user)));
      },
      child: Card(
        elevation: 7,
        child: Column(
          children: <Widget>[
            if(post.imageUrl!=null&&post.imageUrl!="")
            Expanded(
              child: Hero(
                tag: "tag" + post.imageUrl.toString(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image(
                      fit: BoxFit.contain,
                      image: CachedNetworkImageProvider(
                        post.imageUrl,
                      )),
                ),
              ),
            ),
            if(post.imageUrl==null||post.imageUrl=="")
            Flexible(child :Center(child : PaddingWith(
              left: 3,
              right: 3,
              widget :MyText(post.title,color: black,),),),),
            PaddingWith(
              top: 3,
              bottom: 3,
              widget :MyText(
              DateHelper().getWeekDay(post.date.weekday) + " " +post.date.day.toString(),
              fontSize: 14,
              color: black,
            ),
            ),
          ],
        ),
      ),
    );
  }
}
