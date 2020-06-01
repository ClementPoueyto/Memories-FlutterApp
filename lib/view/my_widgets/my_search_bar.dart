import 'package:flutter/material.dart';

class MySearchBar extends TextField{
  MySearchBar({
    @required TextEditingController controller,
    Function onsubmitted,
    TextInputType type : TextInputType.text,
    String hint: "",
    IconData icon,
    bool obscure: false,
    labelText: '',
    maxLines: 1,
  }) : super(
      controller : controller,
      keyboardType: type,
      obscureText : obscure,
      maxLines : maxLines,
      onSubmitted: onsubmitted,
      decoration : InputDecoration(
          contentPadding: EdgeInsets.zero,

          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(40.0),
            ),),
          labelText: labelText,
          labelStyle: TextStyle(color :Colors.black),
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: Colors.black,
          ),
          filled: true,
          fillColor: Colors.white

      )
  );
}