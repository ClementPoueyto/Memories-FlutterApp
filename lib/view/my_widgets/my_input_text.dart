import 'package:flutter/material.dart';

class MyInputTextField extends TextField{
  MyInputTextField({
    @required TextEditingController controller,
    TextInputType type : TextInputType.text,
    String hint: "",
    IconData icon,
    bool obscure: false,
    labelText: '',
    maxLines: null,
  }) : super(
      controller : controller,
      keyboardType: type,
      obscureText : obscure,
      maxLines : maxLines,
      decoration : InputDecoration(
        labelText :labelText,
        labelStyle: TextStyle(color :Colors.red),
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: Colors.red,
        ),

      )
  );
}