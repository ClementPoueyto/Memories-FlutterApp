import 'package:flutter/material.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/api_post_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/tiles/comment_tile.dart';
import 'package:memories/view/tiles/post_tile.dart';
import 'package:memories/models/comment.dart';


class DetailPostPage extends StatefulWidget {
  final User user;
  final Post post;

  DetailPostPage(this.post, this.user);
  DetailPostState createState() => DetailPostState();
}

class DetailPostState extends State<DetailPostPage>{



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiPostHelper().getPostById(widget.post.id),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Post newPost = snapshot.data;
          return ListView.builder(
              itemCount: newPost.comments.length + 1,
              itemBuilder: (BuildContext ctx, int index) {
                if (index == 0) {
                  return PostTile(post: newPost, user: widget.user, detail: false, notifyParent: refresh,);
                } else {
                  Comment comment = Comment(newPost.comments[index - 1]);
                  return PaddingWith(
                    top: 0,
                    bottom: 10,
                    widget :CommentTile(comment),);
                }
              });
        } else {
          return LoadingCenter();
        }
      },
    );
  }

  refresh(String idPost) async {
    setState(() {
    });
  }

}