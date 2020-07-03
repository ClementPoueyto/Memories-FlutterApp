import 'package:flutter/material.dart';
import 'package:memories/controller/add_post_controller.dart';
import 'package:memories/models/comment.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/api_post_helper.dart';
import 'package:memories/util/api_user_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/page/detail_post_page.dart';

///Affiche un post entierement sur une page avec la liste des commentaires
class DetailPost extends StatefulWidget {
  final User user;
  final Post post;
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<List<Post>> notifierPosts;

  DetailPost(this.post, this.user, this.notifierPosts);

  DetailPostState createState() => DetailPostState();

}

  class DetailPostState extends State<DetailPost>{

    Future<List<User>> users;
    Future<Post> post;
    ValueNotifier<Post> notifierPost= new ValueNotifier(null);

  @override
  void initState() {
    super.initState();
   refreshData();

  }

  refreshData(){
    ApiPostHelper().getPostById(widget.post.id).then((value) => {
      this.notifierPost.value=value,
      users= fetchUsersComment(sortCommentUserId(widget.post.comments))
    });
  }

  @override
  Widget build(BuildContext context) {


    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          if (widget.post.userId == me.uid)
            MyIconButton(
              icon: editIcon,
              function: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPost(widget.post,widget.notifierPosts)));
              },
            )
        ],
      ),
      backgroundColor: white,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
              child: InkWell(
            child: ValueListenableBuilder<Post>(
            valueListenable: this.notifierPost,
              builder: (context, value, child) {
                Post newPost =value;
                return FutureBuilder(
                    future: (users),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        List<User> usersComment = snapshot.data;
                        return DetailPostPage(
                            newPost, widget.user, widget.notifierPosts,
                            this.notifierPost, usersComment);
                      }
                      else {
                        return LoadingCenter();
                      }
                    }

                );

              }
          ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },),
          ),
          Divider(
            thickness: 2,
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 0.6), //(x,y)
                  blurRadius: 1.0,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(25)),
              border: Border.all(
                color: whiteShadow,
              ),
              color: white,
            ),
            child: PaddingWith(
              top: 0,
              bottom: 20,
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: PaddingWith(
                      left: 10,
                      widget: Container(
                        width: MediaQuery.of(context).size.width - 100.0,
                        child: Form(
                          key: widget._formKey,
                          child: MyFormTextField(
                            validator: validatorComment,
                            controller: controller,
                            labelText: "Commentaire",
                            hint: "Ecrivez un commentaire",
                            icon: Icons.message,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: sendIcon,
                    onPressed: () {
                      if (widget._formKey.currentState.validate()) {
                        sendComment(context, controller);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  ///Valide le commentaire
  String validatorComment(value) {
    if (value.length > 100) {
      return "100 caractères maximum";
    }
    return null;
  }

  ///Envoie le commentaire via appel api
  sendComment(BuildContext context, TextEditingController controller)async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (controller.text != null && controller.text != "") {
      Map<String, dynamic> map = {
        keyUid: me.uid,
        keyTextComment: controller.text,
        keyDate: DateTime.now().millisecondsSinceEpoch,
      };
      Comment commentToAdd = await ApiPostHelper().addComment(map, widget.post.id);
      widget.notifierPosts.value.firstWhere((element) => element.id==widget.post.id).comments.add(commentToAdd);
      widget.notifierPosts.notifyListeners();
      setState(() {
        refreshData();
      });
    }
  }

    List<String> sortCommentUserId(List<Comment> comments){
      List<String> idsToReturn=List();
      for(Comment comment in comments){
        if(!idsToReturn.contains(comment.userId)){
          idsToReturn.add(comment.userId);
        }
      }
      return idsToReturn;
    }

    Future<List<User>> fetchUsersComment(List<dynamic> ids){
      return ApiUserHelper().getUsersFromIds(ids);
    }
}
