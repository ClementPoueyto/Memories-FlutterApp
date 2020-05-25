import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/delegate/header_post_delegate.dart';
import 'package:memories/models/post.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/my_widgets/loadingCenter.dart';
import 'package:memories/delegate/header_delegate.dart';
import 'package:memories/view/tiles/post_tile.dart';

class ProfilePostsPage extends StatefulWidget {
  final bool isme;
  final User user;
  final List<DocumentSnapshot> documents;
  final Map<Months, List<Post>> listPosts;
  ProfilePostsPage(this.isme,this.user, this.documents, this.listPosts);

  _ProfilePostsState createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePostsPage> {
  ScrollController controller;
  double _expanded = 200.0;
  bool get _showTitle {
    return controller.hasClients &&
        controller.offset > _expanded - kToolbarHeight;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = ScrollController();
    print("check docs : "+widget.documents.length.toString());
  }

  @override
  void dispose() {
    if (controller != null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
              controller: controller,
              slivers: list(widget.documents)
            );

  }

  List<Widget> list(List<DocumentSnapshot> documents){
    List<Widget> list = List();
    list.add(SliverAppBar(
      expandedHeight: _expanded,
      actions: <Widget>[
        (widget.isme)?
        MyIconButton(icon: settingsIcon, color: Colors.red, function: (){FireHelper().logOut();}):Text("demande ami")
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
            widget.user.firstName + " " + widget.user.lastName),
        background: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider((widget
                      .user.imageUrl !=
                      null &&
                      widget.user.imageUrl != "")
                      ? widget.user.imageUrl
                      : "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1901&q=80"),
                  fit: BoxFit.cover)),
          child: Center(
            child: ProfileImage(
              urlString: widget.user.imageUrl,
              onPressed: null,
              size: 50,
            ),
          ),
        ),
      ),
    ),
     );
    list.add(
      SliverPersistentHeader(
        pinned: false,
        delegate: MyHeader(
            user: widget.user, callback: null, scrolled: _showTitle),
      ),);
    Months.values.reversed.forEach((element) {
      if(widget.listPosts[element].length>0){
      list.add(SliverPersistentHeader(
        pinned: false,
        delegate: MyHeaderPost(
            month: element.toString().split('.').last,
            year: "2020",
            callback: () {},
            scrolled: _showTitle),
      ),);
      list.add(SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          delegate: SliverChildListDelegate([
            for(Post post in widget.listPosts[element])
              PostTile(post: post, user: widget.user)
          ])),);
    }});

    return list;
  }



}
