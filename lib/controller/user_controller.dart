import 'package:flutter/material.dart';
import 'package:memories/controller/log_in_controller.dart';
import 'package:memories/controller/register_controller.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/page/profile_page.dart';

class UserController extends StatefulWidget {
  final User user;
  UserController(this.user);

  _UserState createState() => _UserState();
}

class _UserState extends State<UserController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteShadow,
      body: ProfilePage(widget.user),
    );
  }

}
