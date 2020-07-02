import 'package:clip_shadow/clip_shadow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memories/main.dart';
import 'package:memories/util/api_user_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/ui/my_clipper.dart';
import 'package:memories/view/ui/my_second_clipper.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

/// Page de connection de l'utilisateur

class LogInController extends StatefulWidget {
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogInController> {
  TextEditingController _mail;
  TextEditingController _pwd;
  final _formKey = GlobalKey<FormState>();

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
      body: GestureDetector(
        onTap: () {
          hideKeyBoard();
        },
        child: SingleChildScrollView(
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
                        height: (MediaQuery.of(context).size.height * (1 / 3)),
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
                        height: (MediaQuery.of(context).size.height * (1 / 3)),
                        child: Container(
                          color: base.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Center(
                      child: MyText(
                        "Se connecter",
                        color: white,
                        fontSize: 50,
                      ),
                    ),
                  ),
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
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        PaddingWith(
                            top: 30,
                            bottom: 15,
                            widget: MyFormTextField(
                                controller: _mail,
                                validator: validatorMail,
                                hint: "Entrez votre adresse mail",
                                labelText: 'Mail',
                                icon: Icons.person)),
                        PaddingWith(
                            top: 15,
                            bottom: 30,
                            widget: MyFormTextField(
                                controller: _pwd,
                                validator: validatorPwd,
                                hint: "Entrez votre mot de passe",
                                obscure: true,
                                labelText: 'Mot de passe',
                                maxLines: 1,
                                icon: Icons.lock)),
                        PaddingWith(
                          top: 20,
                          widget: Hero(
                            tag: "loginButton",
                            child: SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: MyButton(
                                function: () {
                                  logIn();
                                  if (_formKey.currentState.validate()) ;
                                },
                                color: accent,
                                textColor: white,
                                borderColor: base,
                                name: "Se connecter",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logIn()async {
    if (_mail.text != null && _mail.text != "") {
      if (_pwd.text != null && _pwd.text != "") {
        final res =await ApiUserHelper().logIn(_mail.text.trim(), _pwd.text, context);
        if(res.id!=null){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', clientToken);
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
        }
      }
    }
  }

  String validatorMail(value) {
    if (value.isEmpty) {
      return 'Merci de remplir ce champ';
    }
    if(!value.contains("@")){
      return 'Adresse mail non valide';
    }
    if(value.length>100){
      return "mail trop long";
    }
    return null;
  }

  String validatorPwd(value) {
    if (value.isEmpty) {
      return 'Merci de remplir ce champ';
    }
    if (value.length < 4) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    if(value.length>100){
      return "mot de passe trop long";
    }
    return null;
  }

  void hideKeyBoard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
