import 'package:flutter/material.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/util/alert_helper.dart';

class RegisterController extends StatefulWidget {
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterController> {
  TextEditingController _firstName;
  TextEditingController _lastName;
  TextEditingController _mail;
  TextEditingController _pwd;
  TextEditingController _pwd2;


  @override
  void initState() {
    super.initState();
    _mail = TextEditingController();
    _pwd = TextEditingController();
    _lastName = TextEditingController();
    _firstName = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _mail.dispose();
    _pwd.dispose();
    _firstName.dispose();
    _lastName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Créer un compte"),
        backgroundColor: Colors.red,
      ),
      body: new GestureDetector(
          onTap: () {
            hideKeyBoard();
          },
          child: SingleChildScrollView(
              child: Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height,
                      child: Column(children: <Widget>[

                        PaddingWith(
                            top: 30,
                            bottom: 15,
                            widget: MyTextField(
                                controller: _firstName,
                                hint: "Entrez votre prénom",
                                labelText: 'Prénom',
                                icon: Icons.person)),
                        PaddingWith(
                            top: 15,
                            bottom: 15,
                            widget: MyTextField(
                                controller: _lastName,
                                hint: "Entrez votre nom",
                                labelText: 'Nom',
                                icon: Icons.person)),
                        PaddingWith(
                            top: 15,
                            bottom: 15,
                            widget: MyTextField(
                                controller: _mail,
                                hint: "Entrez votre adresse mail",
                                labelText: 'Mail',
                                icon: Icons.person)),
                        PaddingWith(
                            top: 15,
                            bottom: 15,
                            widget: MyTextField(
                                controller: _pwd,
                                hint: "Entrez votre mot de passe",
                                obscure: true,
                                maxLines: 1,
                                labelText: 'Mot de passe',
                                icon: Icons.lock)),
                        PaddingWith(
                            top: 15,
                            bottom: 30,
                            widget: MyTextField(
                                controller: _pwd2,
                                hint: "Répétez votre mot de passe",
                                obscure: true,
                                maxLines: 1,
                                labelText: 'Confirmer le mot de passe',
                                icon: Icons.lock)),
                        PaddingWith(
                          top: 20,
                          widget: MyButton(
                            function: () {
                              signIn();
                            },
                            name: "Se connecter",
                          ),
                        )
                      ]))))),
    );
  }

  void signIn(){
    if(_mail.text!=null&&_mail.text!=""){
      if(_pwd.text!=null&&_pwd.text!=""){
        if(_firstName.text!=null&&_firstName.text!=""){
          if(_lastName.text!=null&&_lastName.text!=""){
            FireHelper().createAccount(_mail.text, _pwd.text,_firstName.text,_lastName.text);
          }
        }
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
