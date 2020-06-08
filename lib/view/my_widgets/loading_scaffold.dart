import 'package:flutter/material.dart';
import 'package:memories/view/my_material.dart';
import 'package:flutter/material.dart';

class LoadingScaffold extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : SafeArea(child : LoadingCenter()),

    );
  }
}