import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/tiles/comment_tile.dart';
import 'package:memories/view/tiles/post_tile.dart';
import 'package:memories/models/comment.dart';

class DetailPostPage extends StatelessWidget {

  User user;
  Post post;

  DetailPostPage(this.post, this.user);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: post.ref.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData&&snapshot.data.exists) {
          Post newPost = Post(snapshot.data);
          return ListView.builder(
              itemCount: newPost.comments.length + 1,
              itemBuilder: (BuildContext ctx, int index) {
                if (index == 0) {
                  return PostTile(post: newPost, user: user, detail: false,);
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

}