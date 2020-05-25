import 'package:flutter/material.dart';
import 'package:memories/models/post.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';


class ProfileMapPage extends StatefulWidget{

  final Map<Months, List<Post>> listPosts;

  ProfileMapPage(this.listPosts);

  _ProfileMapState createState() => _ProfileMapState();
}

class _ProfileMapState extends State<ProfileMapPage>{
  @override
  Widget build(BuildContext context) {

    return Center(child : Text(widget.listPosts.length.toString()),);
  }
}