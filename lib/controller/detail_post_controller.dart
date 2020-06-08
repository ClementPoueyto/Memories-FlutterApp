import 'package:flutter/material.dart';
import 'package:memories/controller/add_post_controller.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/page/detail_post_page.dart';

class DetailPost extends StatelessWidget {
  User user;
  Post post;
  final _formKey = GlobalKey<FormState>();

  DetailPost(this.post, this.user);

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
                    MaterialPageRoute(builder: (context) => AddPost(post)));
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

  String validatorComment(value) {
    if (value.length > 100) {
      return "100 caractères maximum";
    }
    return null;
  }

  sendComment(BuildContext context, TextEditingController controller) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (controller.text != null && controller.text != "") {
      FireHelper().addComment(post.ref, controller.text, post.userId);
    }
  }
}
