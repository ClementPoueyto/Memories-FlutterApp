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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(12.0),
      ),
      elevation: 6,
      color:base ,
      child :PaddingWith(
        widget :
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          MyText(month,color: white,),
          MyText(year,color: white, )
        ],
      ),),
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