import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/date_helper.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/tiles/post_tile.dart';

class FeedPage extends StatefulWidget {
  User me;
  FeedPage(this.me);
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedPage> {
  StreamSubscription sub;
  List<Post> posts = [];
  List<User> users = [];
  Post memory;
  double expanded=0;
  Map<String, List<Post>> sameDay;

  @override
  void initState() {
    super.initState();
    sameDay=Map();
    sameDay.clear();
    setupSub();
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext build, bool scrolled) {
        return [
          SliverAppBar(
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Memories"),
              background: StreamBuilder<QuerySnapshot>(
                  stream: FireHelper().postsFrom(widget.me.uid),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return LoadingCenter();
                    } else {
                      if (memory == null){
                        this.memory = getMemory(snapshot);
                       if(memory==null) return Center(child: MyText("Pas de souvenir aujourd'hui"),);
                    }
                      return Stack(
                        children: <Widget>[
                          (memory.imageUrl!=null&&memory.imageUrl!="")?ClipRRect(
                            borderRadius: BorderRadius.circular(18.0),
                            child:
                            Image(
                              fit: BoxFit.fitWidth,
                              width: MediaQuery.of(context).size.width,
                              image: CachedNetworkImageProvider(
                                memory.imageUrl,
                              ),
                            ),
                          ):SizedBox.shrink(),
                          Positioned(
                            top: 40,
                            left: 10,
                            child:
                              Container(
                                decoration: BoxDecoration(
                                  color:base,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(
                                    color: accent,
                                  ),
                                ),
                                child:PaddingWith(
                                  top:5,
                                  bottom:5,
                                  left:10,
                                  right:10,
                                  widget: MyText(
                                  "Le " +
                                      DateHelper().myDate(memory.date) +
                                      "...",
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            ),
            expandedHeight: 200,

          )
        ];
      },
      body: posts.length==0?Center(child :MyText("Aucune publication n'est disponible",color: black,),):ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            Post post = posts[index];
            User user = users.firstWhere((u) => u.uid == post.userId);
            if(sameDay[DateHelper().myDate(post.date)]!=null&&!sameDay[DateHelper().myDate(post.date)].contains(post)){
              sameDay[DateHelper().myDate(post.date)].add(post);
            }
            else{
              sameDay[DateHelper().myDate(post.date)]=[];
              sameDay[DateHelper().myDate(post.date)].add(post);
            }
            if (sameDay[DateHelper().myDate(post.date)].length>1) {
              return PostTile(
                post: post,
                user: user,
                detail: true,
              );
            } else {
              return Column(
                children: <Widget>[
                  PaddingWith(
                    widget: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: accent,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 2.0,
                          ),
                        ],
                        color: base,
                        border: Border.all(
                          color: accent,
                        ),
                      ),
                      child: Center(
                        child: MyText(
                          DateHelper().isToday(post.date)
                              ? "Aujourd'hui"
                              : DateHelper().myDate(post.date),
                          color: white,
                        ),
                      ),
                    ),
                  ),
                  PostTile(
                    post: post,
                    user: user,
                    detail: true,
                  )
                ],
              );
            }
          }),
    );
  }

  setupSub() {
    sub = FireHelper()
        .fire_user
        .where(keyFollowers, arrayContains: widget.me.uid).where(keyIsPrivate, isEqualTo: false)
        .snapshots()
        .listen((datas) {
      getUsers(datas.documents);
      datas.documents.forEach((docs) {
        docs.reference.collection("posts").where(keyIsPrivate, isEqualTo: false).snapshots().listen((post) {
          if (mounted) {
            setState(() {
              posts = getPosts(post.documents);
            });
          }
        });
      });
    });
  }

  getUsers(List<DocumentSnapshot> userDocs) {
    List<User> myList = users;
    userDocs.forEach((u) {
      User user = User(u);
      if (myList.every((p) => p.uid != user.uid)) {
        myList.add(user);
      } else {
        User toBeChanged = myList.singleWhere((p) => p.uid == user.uid);
        myList.remove(toBeChanged);
        myList.add(user);
      }
    });
    setState(() {
      users = myList;
    });
  }

  List<Post> getPosts(List<DocumentSnapshot> postDocs) {
    List<Post> myList = posts;
    postDocs.forEach((p) {
      Post post = Post(p);
      if (myList.every((p) => p.ref != post.ref)) {
        myList.add(post);
      }
      else {
        setState(() {
          sameDay=Map();
          Post toBeChanged =
          myList.singleWhere((p) => p.ref == post.ref);
          myList.remove(toBeChanged);
          myList.add(post);
        });


      }
    });
    myList.sort((a, b) => b.date.compareTo(a.date));
    return myList;
  }

  Post getMemory(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Post> myPosts = [];
    for (DocumentSnapshot doc in snapshot.data.documents) {
      myPosts.add(Post(doc));
    }
    DateTime today = DateTime.now();
    for (Post post in myPosts) {
      if (post.date.day == today.day &&
          post.date.month == today.month &&
          post.date.year == today.year - 1) {
        return post;
      }
      if (post.date.day == today.day &&
          post.date.month == today.month - 1 &&
          post.date.year == today.year) {
        return post;
      }
      if (post.date.day == today.day-7 &&
          post.date.month == today.month &&
          post.date.year == today.year) {
        return post;
      }

    }
    return null;
  }
}
