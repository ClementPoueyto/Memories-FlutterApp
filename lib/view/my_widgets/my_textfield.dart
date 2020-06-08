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
    onChanged,

}) : super(
    onChanged:onChanged,
      validator: validator,
    controller : controller,
    keyboardType: type,
    obscureText : obscure,
    maxLines : maxLines,
    decoration : InputDecoration(
      labelText :labelText,
      labelStyle: TextStyle(color :black),
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: base,
      ),

    )
  );


}