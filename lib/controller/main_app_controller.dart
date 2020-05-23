import 'dart:async';
import 'package:memories/controller/add_post_controller.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:flutter/material.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/page/feed_page.dart';
import 'package:memories/view/page/notification_page.dart';
import 'package:memories/view/page/profile_page.dart';
import 'package:memories/view/page/search_page.dart';
import 'package:memories/view/page/add_post.dart';

class MainAppController extends StatefulWidget{

  String uid;
  MainAppController(this.uid);
  _MainState createState() => _MainState();
}

class _MainState extends State<MainAppController>{
  StreamSubscription streamListener;
  int index=0;

  @override
  void initState() {
    super.initState();
    streamListener = FireHelper().fire_user.document(widget.uid).snapshots().listen((document) {
      setState(() {
        me= User(document);
        print(me.lastName);
      });
    });
  }

  @override
  void dispose() {
    streamListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (me==null)?LoadingScaffold()
        :Scaffold(
        bottomNavigationBar: BottomBar(items:
            [BarItem(icon : homeIcon, onPressed: (()=> buttonSelected(0)), selected: index==0,),
            BarItem(icon : searchIcon, onPressed: (()=> buttonSelected(1)), selected: index==1,),
            SizedBox(),
            BarItem(icon : profileIcon, onPressed: (()=> buttonSelected(2)), selected: index==2,),
            BarItem(icon : notificationIcon, onPressed: (()=> buttonSelected(3)), selected: index==3,)]
        ),
        body : showPage(),
        backgroundColor: Colors.grey,
      floatingActionButton: FloatingActionButton(onPressed: push, child: addIcon,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  push(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost()));
  }

  buttonSelected(int index){
    setState(() {
      this.index=index;
    });
    print(index);
  }

  Widget showPage(){
    switch(index){
      case 0 : return FeedPage();
      case 1 : return SearchPage();
      case 2 : return ProfilePage();
      case 3 : return NotificationPage();

    }
  }
}