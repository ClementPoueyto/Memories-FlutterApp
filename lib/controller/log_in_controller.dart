import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/util/alert_helper.dart';
import 'package:memories/util/fire_helper.dart';

class LogInController extends StatefulWidget {
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogInController> {
  TextEditingController _mail;
  TextEditingController _pwd;

  @override
  void initState() {
    super.initState();
    _mail = TextEditingController();
    _pwd = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _mail.dispose();
    _pwd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Se connecter"),
        backgroundColor: Colors.red,
      ),
      body: GestureDetector(
          onTap: () {
            hideKeyBoard();
          },
          child: SingleChildScrollView(
            child : Center(
            child: Container(
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height,
              child: Column(
                  children: <Widget>[
                PaddingWith(
                top: 30,
                bottom: 15,
                widget: MyTextField(
                    controller: _mail,
                    hint: "Entrez votre adresse mail",
                    labelText: 'Mail',
                    icon: Icons.person)),
            PaddingWith(
                top: 15,
                bottom: 30,
                widget: MyTextField(
                    controller: _pwd,
                    hint: "Entrez votre mot de passe",
                    obscure: true,
                    labelText: 'Mot de passe',
                    maxLines: 1,
                    icon: Icons.lock)),
            PaddingWith(
              top: 20,
              widget: MyButton(
                function: () {logIn();},
                name: "Se connecter",
              ),
            )
          ]))))),
    );
  }

  void logIn(){
    if(_mail.text!=null&&_mail.text!=""){
      if(_pwd.text!=null&&_pwd.text!=""){
        FireHelper().signIn(_mail.text, _pwd.text);
      }
      else{
        //alerte mdp vide
      }
    }
    else{
      AlertHelper().error(context, "Aucune adresse email");
      //alerte mail vide
    }
  }


  void hideKeyBoard(){
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
