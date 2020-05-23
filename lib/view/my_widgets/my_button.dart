import 'package:flutter/material.dart';

class MyButton extends RaisedButton{
  MyButton({
    @required Function function,
    String name,
    Color color,

  }) :super(
    onPressed:function,
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(18.0),
      side: BorderSide(color: Colors.grey),
    ),
    child: Text(name),
    color: color
  );
}