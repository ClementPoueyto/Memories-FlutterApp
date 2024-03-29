
import 'package:flutter/material.dart';
import 'package:memories/view/my_material.dart';

class BottomBar extends BottomAppBar {

  BottomBar({@required List<Widget> items, bool shapeCircular : false, Color color : base}) : super(
    shape: shapeCircular?CircularNotchedRectangle():null,
    color : color,
    child : Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: items,
    )
  );
}