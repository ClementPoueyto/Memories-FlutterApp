import 'package:memories/controller/user_controller.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';
import 'package:flutter/material.dart';
import 'package:memories/util/api_user_helper.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/page/profile_page.dart';
class UserTile extends StatefulWidget{
  User user;
  Function notifyParent;
  final ValueNotifier<List<Post>> notifierPosts;

  UserTile(this.user,this.notifyParent,this.notifierPosts);

  UserTileState createState() => UserTileState();

}

class UserTileState extends State<UserTile>{
  User user;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    user=widget.user;
  }
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: ()async{
        final result =await Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext ctx){
            return UserController(user,widget.notifierPosts);
          }
        ));
          widget.notifyParent();
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.all(2.5),
        child: Card(
          color: Colors.white,
          elevation: 5.0,
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ProfileImage(urlString: user.imageUrl, onPressed: null,),
                    PaddingWith(
                      right: 20,
                      left: 20,
                      widget:Text("${user.firstName} ${user.lastName}"),),
                  ],
                ),
                MyButton(color: me.following.contains(user.uid)? Colors.red:Colors.white,name :me.following.contains(user.uid)?"Se désabonner":"Suivre",borderColor: black,textColor:me.following.contains(user.uid)?white:black ,
                  function: (){ update();
                  },),
              ],
            ),
          ),
        ),
      ),
    );
  }

  update()async{
     User updated =await ApiUserHelper().follow(user.uid);
    me=updated;
     widget.notifyParent();
  }
}