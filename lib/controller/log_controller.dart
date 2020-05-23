import 'package:flutter/material.dart';
import 'package:memories/controller/log_in_controller.dart';
import 'package:memories/controller/register_controller.dart';
import 'package:memories/view/my_material.dart';

class LogController extends StatefulWidget {
  _LogState createState() => _LogState();
}

class _LogState extends State<LogController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
      },
      child: SingleChildScrollView(
          child: Column(children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height/1.5),
          decoration: MyGradient(startColor: Colors.red, endColor: Colors.orange),
        ),
        Container(
          height:(MediaQuery.of(context).size.height/3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PaddingWith(widget :MyButton(name:"Se connecter" , function: (){Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LogInController()));},)),
              PaddingWith(widget :MyButton(name:"Créer un compte" , function: (){Navigator.push(
                  context, MaterialPageRoute(builder: (context) => RegisterController()));},)),
            ],
          ),
        )
      ])),
    ));
  }


}
