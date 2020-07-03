import 'package:flutter/material.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';

import 'package:memories/view/my_material.dart';
import 'package:memories/view/tiles/comment_tile.dart';
import 'package:memories/view/tiles/post_tile.dart';
import 'package:memories/models/comment.dart';


class DetailPostPage extends StatefulWidget {
  final User user;
  final Post post;
  final ValueNotifier<List<Post>> notifierPosts;
  final ValueNotifier<Post> notifierPost;
  final List<User> usersComment;
  DetailPostPage(this.post, this.user,this.notifierPosts,this.notifierPost,this.usersComment);
  DetailPostPageState createState() => DetailPostPageState();
}

class DetailPostPageState extends State<DetailPostPage>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
          return ListView.builder(
              itemCount: widget.post.comments.length + 1,
              itemBuilder: (BuildContext ctx, int index) {
                if (index == 0) {
                  return PostTile(post: widget.post, user: widget.user, detail: false,notifierPosts: widget.notifierPosts,notifierPost: widget.notifierPost,);
                } else {
                  Comment comment = widget.post.comments[index - 1];

                  return PaddingWith(
                    top: 0,
                    bottom: 10,
                    widget :
                    widget.usersComment!=null&&widget.usersComment.where((element) => element.uid==comment.userId).length>0?CommentTile(comment, widget.usersComment.firstWhere((element) => element.uid==comment.userId),):LoadingCenter());
                }
              });

  }

  refresh()  {
    setState(() {
    });
  }


}