import 'package:flutter/material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';

class SettingsController extends StatefulWidget {
  final User user;
  SettingsController(this.user);
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<SettingsController> {
  bool isAccountPrivate;

  @override
  void initState() {
    super.initState();
    isAccountPrivate = widget.user.isPrivate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          "Paramètres du compte",
          color: white,
        ),
      ),
      body: Column(
        children: <Widget>[
          PaddingWith(
            top: 20,
            widget: Center(
              child: MyText(
                "Informations du compte",
                color: black,
                fontSize: 25,
              ),
            ),
          ),
          Divider(),
          PaddingWith(widget :Center(child :MyText("Mon pseudo : "+ widget.user.pseudo,color: black ,),),),
          Divider(),
          PaddingWith(
            widget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MyText(
                  "Public",
                  color: black,
                ),
                Radio(
                  value: false,
                  groupValue: isAccountPrivate,
                  onChanged: (val) {
                    setState(() {
                      isAccountPrivate = val;
                    });
                  },
                ),
                Container(
                  width: 30,
                ),
                MyText(
                  "Privé",
                  color: black,
                ),
                Radio(
                  value: true,
                  groupValue: isAccountPrivate,
                  onChanged: (val) {
                    setState(() {
                      isAccountPrivate = val;
                    });
                  },
                ),
              ],
            ),
          ),
          PaddingWith(
            left: 15,
            right: 15,
            bottom: 15,
            top: 5,
            widget: Center(
              child: MyText(
                (isAccountPrivate?"Plus personne":"Tout le monde")+" ne pourra accéder à votre profil et voir vos publications",
                color: Colors.grey,
              ),
            ),
          ),
          MyButton(
            function: () {
              Map<String, dynamic> data = {keyIsPrivate: isAccountPrivate};
              Navigator.pop(context);
              FireHelper().modifiyUser(data);
            },
            name: "Valider",
            color: base,
            textColor: white,
            borderColor: accent,
          )
        ],
      ),
    );
  }
}
