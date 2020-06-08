import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';


class ProfileTagsPage extends StatefulWidget{

  _ProfileTagsState createState() => _ProfileTagsState();
}

class _ProfileTagsState extends State<ProfileTagsPage>{
  @override
  Widget build(BuildContext context) {

    return LoadingCenter();
  }
}