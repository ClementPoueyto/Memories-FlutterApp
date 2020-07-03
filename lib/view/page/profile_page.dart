import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/models/post.dart';
import 'package:memories/util/api_post_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/my_widgets/loadingCenter.dart';
import 'package:memories/view/page/profile_posts_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final ValueNotifier<List<Post>> notifierPosts;

  ProfilePage(this.user,this.notifierPosts);

  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  bool _isme = false;
  int index = 0;
  var _pages;
  var _pageController = PageController();
  File imageTaken;
  StreamSubscription postsSubscription;

  ScrollController scrollController;

  Map<String, List<Post>> list=Map();
  Future<List<Post>> userPosts;

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

            child: FutureBuilder(
                future: userPosts,
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {

                    if(_isme&&myListPosts!=null&&myListPosts.length!=0){
                      sortPosts(myListPosts);
                      _pages = [
                        ProfilePostsPage(
                            this._isme, widget.user, this.list,widget.notifierPosts),
                        //ProfileTagsPage(),

                      ];
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
                    else{
                      return LoadingCenter();
                    }
                  } else {
                    sortPosts(snapshot.data);

                    if(_isme){
                      _pages = [
                        ProfilePostsPage(
                            this._isme, widget.user, this.list,widget.notifierPosts),
                        //ProfileTagsPage(),

                      ];
                    }
                    if(!_isme&&widget.user.isPrivate) {
                      _pages = [
                        ProfilePostsPage(
                            this._isme, widget.user, this.list,widget.notifierPosts),
                      ];
                    }
                    else{
                      _pages = [
                        ProfilePostsPage(
                            this._isme, widget.user, this.list,widget.notifierPosts),
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

      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _isme = (widget.user.uid == me.uid);
    scrollController = ScrollController();
    if(_isme) {
      ApiPostHelper().getMyPosts().then((value) =>
      postController.add(value));
      postsSubscription =mePosts.listen((event) {
        myListPosts = event;
        userPosts = Future.value(event);
        setState(() {

        });
      });
    }
    else{
      userPosts = ApiPostHelper().getPostFromId(widget.user.uid);
    }

  }

  @override
  void dispose() {
    if (_pageController != null) {
      _pageController.dispose();
    }
    if (scrollController != null) {
      scrollController.dispose();
    }
    if(postsSubscription != null){
      postsSubscription.cancel();
    }

    super.dispose();
  }

  void buttonSelected(int pageSelected) {
    setState(() {
      _pageController.animateToPage(pageSelected,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
      this.index = pageSelected;
    });
  }

  void sortPosts(List<Post> posts){
    this.list=Map();
    posts.sort((a,b) {
      DateTime adate =  a.date;
      DateTime bdate = b.date;
      return bdate.compareTo(adate);
    });
    for(Post post in posts){
      DateTime date = post.date;
      String keyMapDate= date.month.toString()+"/"+date.year.toString();
      if(this.list[keyMapDate]==null){
        this.list[keyMapDate]=[];
      }
      this.list[keyMapDate].add(post);

    }
  }


}
