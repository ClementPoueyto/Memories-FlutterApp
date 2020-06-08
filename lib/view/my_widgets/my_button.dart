import 'package:flutter/material.dart';
import 'package:memories/view/my_material.dart';

class MyButton extends RaisedButton{
  MyButton({
    @required Function function,
    String name,
    Color color,
    Color borderColor:Colors.grey,
    Color textColor : black,
    double size : 15,
  }) :super(
    onPressed:function,
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(18.0),
      side: BorderSide(color: borderColor),
    ),
    child: MyText(
      name,color: textColor,fontSize: size,
    ),
    color: color
  );
}