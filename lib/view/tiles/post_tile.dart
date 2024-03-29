import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memories/controller/detail_post_controller.dart';
import 'package:memories/controller/user_controller.dart';
import 'package:memories/models/user.dart';
import 'package:memories/models/post.dart';
import 'package:memories/util/api_post_helper.dart';
import 'package:memories/util/date_helper.dart';

import 'package:memories/view/my_material.dart';

class PostTile extends StatelessWidget{
  final Post post;
  final User user;
  final bool detail;
  final ValueNotifier<List<Post>> notifierPosts;
  final ValueNotifier<Post> notifierPost;
  final Function notifyParent;
  PostTile({@required Post this.post, @required User this.user, bool this.detail : false, ValueNotifier<List<Post>> this.notifierPosts,ValueNotifier<Post> this.notifierPost ,this.notifyParent});

  @override
  Widget build(BuildContext context) {

    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all( 5.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 10,
          child :GestureDetector(
            onTap: (){
              if(user.uid!=me.uid&&detail==true)
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserController(user,this.notifierPosts)));},
          child :Column(
              children: <Widget>[
              PaddingWith(
                top: 5,
                bottom: 5,
                widget :Row(
                children: <Widget>[
                  PaddingWith(
                    left:10,
                    right: 5,
                    top: 0,
                    bottom: 0,
                    widget :ProfileImage(
                    urlString: user.imageUrl,
                  ),),
                  PaddingWith(
                    left: 10,
                      right:5,
                      widget :MyText(user.firstName+" "+user.lastName, color: black,)),
                  Expanded(child: SizedBox(),),
                  PaddingWith(
                    right: 15,
                      widget :MyText(DateHelper().getTime(post.date),color: black,))
              ],
              ),),
                    ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),

                  child: (post.imageUrl!=null&&post.imageUrl!="")?Image(
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width,
                      image: CachedNetworkImageProvider(post.imageUrl,)
                  ):SizedBox.shrink(),
                    ),



              Container(
                child: Column(children: <Widget>[
                  PaddingWith(
                    left: 10,
                    right:10,
                    widget: MyText(post.title, color: black, fontSize: 20,),
                  ),
                  if(post.adress!=null)
                    PaddingWith(
                      left: 5,
                      right:5,
                      top: 0,
                      bottom: 0,
                      widget: MyText("à "+post.adress, color: black, fontSize: 15,),
                    ),
                    PaddingWith(
                      left: 5,
                      right:5,
                      top: 0,
                      bottom: 0,
                      widget: MyText("le "+DateHelper().myDate(post.date), color: black, fontSize: 15,),
                    ),
                  if(post.description!=null)
                    PaddingWith(
                      left: 5,
                    right:5,
                    widget: MyText(post.description, color: black, fontSize: 15,),
                  ),
                ],),
              ),

              Container(
                height: 50,
                  child :Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          MyIconButton(function: ()async{
                            Post updatedPost = await ApiPostHelper().likePost(post.id);
                            update(updatedPost);
                            },icon: post.likes.contains(me.uid)?likeIconFull:likeIcon,),
                          Text(post.likes.length.toString()),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          MyIconButton(function: (){if(detail==true){Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPost(post,user,this.notifierPosts)));}},icon: commentsIcon,),
                          Text(post.comments.length.toString()),
                        ],
                      ),
                    ],
                  )
              ),

            ],)
        ),
        )
    );
  }

  update(Post post)async{
    this.notifierPosts.value.removeWhere((element) => element.id==post.id);
    this.notifierPosts.value.add(post);
    this.notifierPosts.notifyListeners();
    if(this.notifierPost!=null){
      this.notifierPost.value=post;
      this.notifierPost.notifyListeners();
    }
    if(this.notifyParent!=null) {
      this.notifyParent();
    }
  }

}