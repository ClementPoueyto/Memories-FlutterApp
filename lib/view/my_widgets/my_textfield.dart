import 'package:flutter/material.dart';
import 'package:memories/view/my_material.dart';

class MyFormTextField extends TextFormField{
  MyFormTextField({
    @required TextEditingController controller,
    TextInputType type : TextInputType.text,
    String hint: "",
    IconData icon,
    bool obscure: false,
    labelText: '',
    validator:null,
    maxLines: null,
}) : super(
      validator: validator,
    controller : controller,
    keyboardType: type,
    obscureText : obscure,
    maxLines : maxLines,
    decoration : InputDecoration(
      labelText :labelText,
      labelStyle: TextStyle(color :black),
      hintText: hint,

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1,color: black),
      ),
      prefixIcon: Icon(
        icon,
        color: base,
      ),

    )
  );


}