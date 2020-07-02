import 'package:flutter/material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/page/profile_page.dart';

///Affiche le profil d'un utilisateur donné
class UserController extends StatefulWidget {
  final User user;
  UserController(this.user);

  _UserState createState() => _UserState();
}

class _UserState extends State<UserController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: PaddingWith(widget :FloatingActionButton(child: closeIcon, onPressed: (){Navigator.pop(context);},)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: whiteShadow,
      body: ProfilePage(widget.user),
    );
  }

}
