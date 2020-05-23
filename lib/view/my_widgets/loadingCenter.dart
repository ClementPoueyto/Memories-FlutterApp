import 'package:flutter/material.dart';
import 'package:memories/view/my_material.dart';

class LoadingCenter extends Center{

  LoadingCenter(): super(
    child : Center(child:Text(
      "Chargement...",style: TextStyle(
      fontSize: 40.0,
    ),
    ))
  );
}