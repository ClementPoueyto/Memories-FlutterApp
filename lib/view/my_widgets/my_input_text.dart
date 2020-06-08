import 'package:flutter/material.dart';
import 'package:memories/view/my_material.dart';
class MyInputTextField extends TextFormField{
  MyInputTextField({
    @required TextEditingController controller,
    TextInputType type : TextInputType.text,
    String hint: "",
    IconData icon,
    bool obscure: false,
    labelText: '',
    maxLines: null,
    validator,
    Color colorText : black,
    Color iconColor : base,
  }) : super(
    validator: validator,
      controller : controller,
      keyboardType: type,
      obscureText : obscure,
      maxLines : maxLines,
      decoration : InputDecoration(
        labelText :labelText,
        labelStyle: TextStyle(color :colorText),
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: iconColor,
        ),

      )
  );
}