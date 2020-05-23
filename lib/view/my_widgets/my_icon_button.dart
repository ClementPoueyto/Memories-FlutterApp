import 'package:flutter/material.dart';

class MyIconButton extends IconButton{
  MyIconButton({
    @required Function function,
    @required Widget icon,
    Color color,

  }) :super(

      icon : icon,
      onPressed:function,
      color: color,

  );
}