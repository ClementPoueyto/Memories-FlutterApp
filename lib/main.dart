import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'controller/main_app_controller.dart';
import 'controller/log_controller.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _handleAuth(),
    );
  }

  Widget _handleAuth(){
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot){
        return (!snapshot.hasData) ? LogController() :MainAppController(snapshot.data.uid);
      },
    );
  }
}

