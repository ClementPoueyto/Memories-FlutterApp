import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memories/controller/add_post_controller.dart';
import 'package:memories/models/notification.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:flutter/material.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/page/feed_page.dart';
import 'package:memories/view/page/notification_page.dart';
import 'package:memories/view/page/profile_page.dart';
import 'package:memories/view/page/search_page.dart';

class MainAppController extends StatefulWidget{

  String uid;
  MainAppController(this.uid);
  _MainState createState() => _MainState();
}

class _MainState extends State<MainAppController>{
  StreamSubscription streamListener;
  List<DocumentSnapshot> notifListener;
  bool _isNotified;

  int index=0;

  @override
  void initState() {
    super.initState();
    _isNotified=false;
    streamListener = FireHelper().fire_user.document(widget.uid).snapshots().listen((document) {
      setState(() {
        me= User(document);
        FireHelper().fire_user.document(me.uid).collection("notifications").snapshots().listen((notifs) {
          isNotified(notifs);
        });
      });
    });
  }

  bool isNotified(QuerySnapshot notifs){
    setState(() {
      bool _shouldBeNotified = false;
      notifs.documents.forEach((element) {
        Notif myNotif = Notif(element);
        if (!myNotif.seen) {
          _shouldBeNotified=true;
        }
      });
      if(_shouldBeNotified==true){
        _isNotified=true;
      }
      else{
        _isNotified=false;
      }
      notifListener =notifs.documents;
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
      endDrawer: MyDrawer(user: me,context: context,),
        bottomNavigationBar: BottomBar(
          color: whiteShadow,
          items:
            [BarItem(icon : homeIcon, onPressed: (()=> buttonSelected(0)), selected: index==0,),
            BarItem(icon : searchIcon, onPressed: (()=> buttonSelected(1)), selected: index==1,),
            SizedBox(),
            BarItem(icon : profileIcon, onPressed: (()=> buttonSelected(2)), selected: index==2,),
            BarItem(icon : _isNotified?Icon(Icons.notifications_active):notificationIcon, onPressed: (()=> buttonSelected(3)), selected: index==3,)],
          shapeCircular: true,
        ),
        body : GestureDetector(
          onTap: hideKeyBoard,
            child :Container(
              height: MediaQuery.of(context).size.height-kToolbarHeight,
                child :showPage())),
        backgroundColor: whiteShadow,
      floatingActionButton: FloatingActionButton(onPressed: push, child: addIcon,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  push(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost(null)));
  }

  buttonSelected(int index){
    setState(() {
      this.index=index;
    });
  }

  void hideKeyBoard(){
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Widget showPage(){
    switch(index){
      case 0 : return FeedPage(me);
      case 1 : return SearchPage();
      case 2 : return ProfilePage(me);
      case 3 : return NotificationPage(notifListener);

    }
  }
}