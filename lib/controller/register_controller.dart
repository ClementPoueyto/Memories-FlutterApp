import 'dart:async';
import 'package:clip_shadow/clip_shadow.dart';
import 'package:flutter/material.dart';
import 'package:memories/util/api_user_helper.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/util/alert_helper.dart';
import 'package:memories/view/ui/my_clipper.dart';
import 'package:memories/view/ui/my_second_clipper.dart';

/// Page d'enregistrement du compte
class RegisterController extends StatefulWidget {
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterController> {
  TextEditingController _firstName;
  TextEditingController _lastName;
  TextEditingController _mail;
  TextEditingController _pwd;
  TextEditingController _pwd2;
  TextEditingController _pseudo;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _mail = TextEditingController();
    _pwd = TextEditingController();
    _pwd2 = TextEditingController();
    _lastName = TextEditingController();
    _firstName = TextEditingController();
    _pseudo = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _mail.dispose();
    _pwd.dispose();
    _pwd2.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _pseudo.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new GestureDetector(
        onTap: () {
          hideKeyBoard();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Hero(
                      tag: "firstClipp",
                      child: ClipShadow(
                        clipper: PrimaryClipper(),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 10,
                              offset: Offset(0.0, 1.0))
                        ],
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height:
                              (MediaQuery.of(context).size.height * (1 / 4)),
                          color: accent,
                        ),
                      ),
                    ),
                    Hero(
                      tag: "secondClipp",
                      child: ClipShadow(
                        clipper: SecondClipper(),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 10,
                              offset: Offset(0.0, 1.0))
                        ],
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height:
                              (MediaQuery.of(context).size.height * (1 / 4)),
                          child: Container(
                            color: base.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height / 4,
                        child: Center(
                          child: MyText(
                            "S'enregistrer",
                            color: white,
                            fontSize: 50,
                          ),
                        )),
                    Positioned(
                      top: 40,
                      right: 10,
                      child: MaterialButton(
                        shape: CircleBorder(),
                        child: Icon(
                          Icons.close,
                          color: accent,
                        ),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: <Widget>[
                        PaddingWith(
                            top: 30,
                            bottom: 15,
                            widget: MyFormTextField(
                                validator: validatorName,
                                controller: _firstName,
                                hint: "Entrez votre prénom",
                                labelText: 'Prénom',
                                icon: Icons.person)),
                        PaddingWith(
                            top: 15,
                            bottom: 15,
                            widget: MyFormTextField(
                                validator: validatorName,
                                controller: _lastName,
                                hint: "Entrez votre nom",
                                labelText: 'Nom',
                                icon: Icons.person)),
                        PaddingWith(
                            top: 15,
                            bottom: 15,
                            widget: MyFormTextField(
                                validator: validatorMail,
                                controller: _mail,
                                hint: "Entrez votre adresse mail",
                                labelText: 'Mail',
                                icon: Icons.mail)),
                        PaddingWith(
                            top: 15,
                            bottom: 15,
                            widget: MyFormTextField(
                                validator: validatorName,
                                controller: _pseudo,
                                hint: "Entrez votre pseudo",
                                obscure: false,
                                maxLines: 1,
                                labelText: 'Pseudo',
                                icon: Icons.mode_edit)),
                        PaddingWith(
                            top: 15,
                            bottom: 15,
                            widget: MyFormTextField(
                                validator: validatorPwd,
                                controller: _pwd,
                                hint: "Entrez votre mot de passe",
                                obscure: true,
                                maxLines: 1,
                                labelText: 'Mot de passe',
                                icon: Icons.lock)),
                        PaddingWith(
                          top: 15,
                          bottom: 30,
                          widget: MyFormTextField(
                              validator: validatorPwd,
                              controller: _pwd2,
                              hint: "Répétez votre mot de passe",
                              obscure: true,
                              maxLines: 1,
                              labelText: 'Confirmer le mot de passe',
                              icon: Icons.lock),
                        ),
                        PaddingWith(
                          widget: Hero(
                            tag: "registerButton",
                            child: SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: MyButton(
                                name: "Créer un compte",
                                textColor: white,
                                color: accent,
                                borderColor: base,
                                function: () {
                                  if (_formKey.currentState.validate())
                                    signIn();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> checkUser(String input) async {
    var user = await FireHelper()
        .fire_user
        .where(keyPseudo, isEqualTo: input.toLowerCase())
        .getDocuments();
    return Future.value(user.documents.length == 0);
  }

  void signIn() async {
    if (_mail.text != null &&
        _mail.text != "" &&
        _pwd.text != null &&
        _pwd.text != "" &&
        _firstName.text != null &&
        _firstName.text != "" &&
        _lastName.text != null &&
        _lastName.text != "" &&
        _pseudo.text != null &&
        _pseudo.text != "") {
      ApiUserHelper()
          .signIn(_mail.text.trim(), _pwd.text, _firstName.text, _lastName.text,
              _pseudo.text, context)
          .then((value) => {
                if (value != null)
                  {Navigator.pop(context)}
                else
                  {
                    AlertHelper().error(context, "Mauvais Pseudo",
                        "Désolé, ce pseudo a déjà été pris")
                  }
              });
    }
  }

  String validatorName(String value) {
    if (value.isEmpty) {
      return 'Merci de remplir ce champ';
    }
    if (value.length > 100) {
      return "champ trop long";
    }
  }

  String validatorMail(String value) {
    if (value.isEmpty) {
      return 'Merci de remplir ce champ';
    }
    if (!value.contains("@")) {
      return 'Adresse mail non valide';
    }
    if (value.length > 100) {
      return "mail trop long";
    }
    return null;
  }

  String validatorPwd(value) {
    if (value.isEmpty) {
      return 'Merci de remplir ce champ';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    if (value.length > 100) {
      return "mot de passe trop long";
    }
    if (_pwd.text != _pwd2.text) {
      return "mots de passe differents";
    }
    return null;
  }

  void hideKeyBoard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
