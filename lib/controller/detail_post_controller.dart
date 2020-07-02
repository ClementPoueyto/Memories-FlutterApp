import 'package:flutter/material.dart';
import 'package:memories/controller/add_post_controller.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/api_post_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/page/detail_post_page.dart';

///Affiche un post entierement sur une page avec la liste des commentaires
class DetailPost extends StatelessWidget {
  final User user;
  final Post post;
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<List<Post>> notifierPosts;
  DetailPost(this.post, this.user,this.notifierPosts);

  @override
  Widget build(BuildContext context) {

    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          if (post.userId == me.uid)
            MyIconButton(
              icon: editIcon,
              function: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPost(post,this.notifierPosts)));
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
            child: DetailPostPage(post, user),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          )),
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
                          key: _formKey,
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
                      if (_formKey.currentState.validate()) {
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
  sendComment(BuildContext context, TextEditingController controller) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (controller.text != null && controller.text != "") {
      Map<String, dynamic> map = {
        keyUid: me.uid,
        keyTextComment: controller.text,
        keyDate: DateTime.now().millisecondsSinceEpoch,
      };
      ApiPostHelper().addComment(map, post.id);
    }
  }
}
