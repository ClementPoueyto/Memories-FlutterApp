import 'package:flutter/material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/my_material.dart';

class MyHeader extends SliverPersistentHeaderDelegate{
  User user;
  VoidCallback callback;
  bool scrolled;
  MyHeader({@required User this.user, @required VoidCallback this.callback, @required bool this.scrolled});


  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 100,
      margin :EdgeInsets.only(bottom: 5.0),
      padding: EdgeInsets.all(10.0),
      color: base ,
      child :
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              InkWell(child: Text("Followers: ${user.followers.length}"),),
              InkWell(child: Text("Following: ${user.following.length-1}"),),
            ],
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => (scrolled) ? 150.0:40.0;

  @override
  // TODO: implement minExtent
  double get minExtent => (scrolled) ? 150.0:40.0;

  @override
  bool shouldRebuild(MyHeader oldDelegate) => scrolled!=oldDelegate.scrolled||user != oldDelegate.user;
}