import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/models/post.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_widgets/loadingCenter.dart';
import 'package:memories/view/page/profile_map_page.dart';
import 'package:memories/view/page/profile_posts_page.dart';
import 'package:memories/view/page/profile_tags_page.dart';

class ProfilePage extends StatefulWidget {
  User user;
  ProfilePage(this.user);

  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  bool _isme = false;
  int index = 0;
  var _pages;
  var _pageController = PageController();
  File imageTaken;

  ScrollController controller;

  Map<String, List<Post>> list=Map();
  StreamSubscription subscription;
  List<DocumentSnapshot> documents;

  @override
  Widget build(BuildContext context) {
    return
      Column(
      children: <Widget>[
        BottomBar(
          color: base,
          items: [
            BarItem(
              selectedColor: white,
              icon: postIcon,
              onPressed: (() => buttonSelected(0)),
              selected: index == 0,
            ),
            /*if((!_isme&&!widget.user.isPrivate)||_isme)
              BarItem(
                selectedColor: white,
                icon: tagIcon,
                onPressed: (() => buttonSelected(1)),
                selected: index == 1,
              ),*/


          ],
        ),

        Expanded(

            child: StreamBuilder<QuerySnapshot>(
                stream: _isme?FireHelper().myPostsFrom(me.uid):FireHelper().postsFrom(widget.user.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return LoadingCenter();
                  } else {
                    documents = snapshot.data.documents;
                    sortPosts(documents);

                    if(_isme){
                      _pages = [
                        ProfilePostsPage(
                            this._isme, widget.user, documents, this.list),
                        //ProfileTagsPage(),

                      ];
                    }
                    if(!_isme&&widget.user.isPrivate) {
                      _pages = [
                        ProfilePostsPage(
                            this._isme, widget.user, documents, this.list),
                      ];
                    }
                    else{
                      _pages = [
                        ProfilePostsPage(
                            this._isme, widget.user, documents, this.list),
                        //ProfileTagsPage(),

                      ];
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child :PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          this.index = index;
                        });
                      },
                      children:
                          _pages != null ? _pages : <Widget>[LoadingCenter()],
                    ),);
                  }
                })),

        if(!_isme) PaddingWith(

          widget :FloatingActionButton(child: closeIcon, onPressed: (){Navigator.pop(context);},))

      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _isme = (widget.user.uid == me.uid);
    controller = ScrollController();

    subscription=FireHelper().fire_user.document(widget.user.uid).snapshots().listen((data) {
      setState(() {
        widget.user=User(data);
      });
    });

  }

  @override
  void dispose() {
    if (_pageController != null) {
      _pageController.dispose();
    }
    if (controller != null) {
      controller.dispose();
    }
    subscription.cancel();
    super.dispose();
  }

  void buttonSelected(int pageSelected) {
    setState(() {
      _pageController.animateToPage(pageSelected,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
      this.index = pageSelected;
    });
  }

  void sortPosts(List<DocumentSnapshot> docs){
    this.list=Map();
    docs.sort((a,b) {
      DateTime adate = a.data[keyDate].toDate();
      DateTime bdate = b.data[keyDate].toDate();
      return bdate.compareTo(adate);
    });
    for(DocumentSnapshot doc in docs){
      DateTime date = doc.data[keyDate].toDate();
      String keyMapDate= date.month.toString()+"/"+date.year.toString();
      if(this.list[keyMapDate]==null){
        this.list[keyMapDate]=[];
      }
      this.list[keyMapDate].add(Post(doc));

    }
  }


}
