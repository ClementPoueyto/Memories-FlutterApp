
import 'package:flutter/material.dart';

class BottomBar extends BottomAppBar {

  BottomBar({@required List<Widget> items, bool shapeCircular : false}) : super(
    shape: shapeCircular?CircularNotchedRectangle():null,
    color : Colors.red,
    child : Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: items,
    )
  );
}