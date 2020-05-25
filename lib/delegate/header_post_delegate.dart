import 'package:flutter/material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/my_material.dart';

class MyHeaderPost extends SliverPersistentHeaderDelegate{
  VoidCallback callback;
  bool scrolled;
  String month;
  String year;

  MyHeaderPost({@required String this.month,@required String this.year,@required VoidCallback this.callback, @required bool this.scrolled});


  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin :EdgeInsets.only(bottom: 5.0),
      padding: EdgeInsets.all(10.0),
      color:Colors.red ,
      child :
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(month),
          Text(year)
        ],
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => (scrolled) ? 150.0:70.0;

  @override
  // TODO: implement minExtent
  double get minExtent => (scrolled) ? 150.0:70.0;

  @override
  bool shouldRebuild(MyHeaderPost oldDelegate) => scrolled!=oldDelegate.scrolled||month != oldDelegate.month;
}