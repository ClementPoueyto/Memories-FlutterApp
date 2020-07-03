import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memories/controller/detail_post_controller.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/api_post_helper.dart';
import 'package:memories/util/api_user_helper.dart';
import 'package:memories/util/date_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/tiles/post_tile.dart';

class FeedPage extends StatefulWidget {
  final User me;
  final ValueNotifier<List<Post>> notifierPosts;
  FeedPage(this.me, this.notifierPosts);
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedPage> {
  Future<List<User>> feedUsers;
  List<User> users;
  Post memory;
  double expanded = 0;
  Map<String, List<Post>> sameDay;

  @override
  void initState() {
    super.initState();

    feedUsers = ApiUserHelper().getMyFollowing();
    feedUsers.then((value) => {
      feedUserPostSave=value,
    });
    sameDay = Map();
    sameDay.clear();
  }

  @override
  void dispose() {
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
                background: memory == null
                    ? Center(
                        child: MyText("Pas de souvenir aujourd'hui"),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPost(
                                      memory, me, widget.notifierPosts)));
                        },
                        child: Stack(
                          children: <Widget>[
                            (memory.imageUrl != null && memory.imageUrl != "")
                                ? Image(
                                    fit: BoxFit.fitWidth,
                                    width: MediaQuery.of(context).size.width,
                                    image: CachedNetworkImageProvider(
                                      memory.imageUrl,
                                    ),
                                  )
                                : PaddingWith(
                                    left: 10,
                                    right: 10,
                                    widget: SizedBox(
                                      child: Center(
                                        child: MyText(
                                          memory.title,
                                          color: white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                            Positioned(
                              top: 40,
                              left: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: base,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(
                                    color: accent,
                                  ),
                                ),
                                child: PaddingWith(
                                  top: 5,
                                  bottom: 5,
                                  left: 10,
                                  right: 10,
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
                        ),
                      )),
            expandedHeight: 200,
          )
        ];
      },
      body: RefreshIndicator(
        child: ValueListenableBuilder<List<Post>>(
            valueListenable: widget.notifierPosts,
            builder: (context, value, child) {
              return FutureBuilder(
                future: feedUsers,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    users = snapshot.data;
                    if(users.length>0&&value.length>0) {
                      return listBuilder(
                          sortPosts(value), users);
                    }
                    else{
                      return Center(
                        child: MyText(
                          "Aucune publication n'est disponible",
                          color: black,
                        ),
                      );
                    }
                  } else {
                    if(feedUserPostSave.length>0&&feedPostSave.length>0){
                      return listBuilder(feedPostSave, feedUserPostSave);
                    }
                    else{
                      return LoadingCenter();
                    }
                  }
                },
              );
            }),
        /**/
        onRefresh: () => ReloadFeed(),
      ),
    );
  }

  Widget listBuilder(List<Post> posts, List<User> users) {
    return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              Post post = posts[index];
              User user = users.firstWhere((u) => u.uid == post.userId);
              if (sameDay[DateHelper().myDate(post.date)] != null &&
                  !sameDay[DateHelper().myDate(post.date)].contains(post)) {
                sameDay[DateHelper().myDate(post.date)].add(post);
              } else {
                sameDay[DateHelper().myDate(post.date)] = [];
                sameDay[DateHelper().myDate(post.date)].add(post);
              }
              if (sameDay[DateHelper().myDate(post.date)].length > 1) {
                return PostTile(
                  post: post,
                  user: user,
                  detail: true,
                  notifierPosts: widget.notifierPosts,
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
                      notifierPosts: widget.notifierPosts,
                    )
                  ],
                );
              }
            });
  }

  ReloadFeed() async {
    users = await ApiUserHelper().getMyFollowing();
    List<String> ids = List();
    for (User user in users) {
      ids.add(user.uid);
    }
    widget.notifierPosts.value = await ApiPostHelper().getMyFeed(ids);

    return widget.notifierPosts.value;
  }


  List<Post> sortPosts(List<Post> postDocs) {
    List<Post> myList = postDocs;
    postDocs.forEach((p) {
      Post post = p;

      if (myList.every((p) => p.id != post.id)) {
        myList.add(post);
      } else {
        sameDay = Map();
        Post toBeChanged = myList.singleWhere((p) => p.id == post.id);
        myList.remove(toBeChanged);
        myList.add(post);
      }
    });
    myList.sort((a, b) => b.date.compareTo(a.date));
    return myList;
  }

  Post getMemory(List<Post> myPosts) {
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
      if (post.date.day == today.day - 7 &&
          post.date.month == today.month &&
          post.date.year == today.year) {
        return post;
      }
    }
    return null;
  }

  refresh(String idPost) async {
    Post postToUpdate = widget.notifierPosts.value
        .firstWhere((element) => element.id == idPost);
    if (postToUpdate.likes.contains(me.uid)) {
      postToUpdate.likes.remove(me.uid);
    } else {
      postToUpdate.likes.add(me.uid);
    }
    setState(() {});
  }
}
