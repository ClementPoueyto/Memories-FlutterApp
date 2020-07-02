import 'package:flutter/material.dart';
import 'constants.dart';

class BarItem extends IconButton{
  BarItem({@required Icon icon, @required VoidCallback onPressed, @required bool selected, Color selectedColor: base, Color color: black}) : super(
    icon : icon,
    onPressed : onPressed,
    color: selected ? selectedColor : color
  );
}