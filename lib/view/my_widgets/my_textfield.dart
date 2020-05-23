import 'package:flutter/material.dart';

class MyTextField extends TextField{
  MyTextField({
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

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1,color: Colors.red),
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.red,
      ),
      border: OutlineInputBorder(
          borderSide: BorderSide(width :1 ,color: Colors.red),
      ),

    )
  );
}