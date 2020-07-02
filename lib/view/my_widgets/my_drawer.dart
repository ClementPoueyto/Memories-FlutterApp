import 'package:flutter/material.dart';
import 'package:memories/controller/settings_controller.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/alert_helper.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';

class MyDrawer extends Drawer {
  MyDrawer({
    @required BuildContext context,
    User user,
    @required Function function,
    String name,
    Color color,
    Color borderColor: Colors.grey,
    Color textColor: black,
  }) : super(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: base
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ProfileImage(urlString: user.imageUrl,size: 40,),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: MyText(user.firstName+" "+user.lastName,fontSize: 20,),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: settingsIcon,
                title: MyText("Paramètres",color: black,),
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsController(user)));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.error),
                title: MyText("Plus d'infos",color: black,),
                onTap: (){
                  showAboutDialog(context: context,
                    applicationName: "Memories",
                    applicationVersion: "0.2"
                  );
                },
              ),
              Divider(),
              Expanded(child: SizedBox(),),
              ListTile(
                leading: Icon(Icons.arrow_back),
                title: MyText("Se deconnecter", color: Colors.red,),
                onTap: (){
                  AlertHelper().logOut(context, "Se deconnecter", "Voulez-vous vraiment vous deconnecter ?");
                },
              )

            ],
          ),
        );
}
