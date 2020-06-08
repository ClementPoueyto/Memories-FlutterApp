import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';

class AlertHelper{
  Future<void> error(BuildContext context,String errorTitle, String error) async{
    Text title = Text(errorTitle);
    Text subtitle = Text(error);
    return showDialog(context: context,
      barrierDismissible: true,
      builder: (BuildContext ctx){
      return (Theme.of(context).platform==TargetPlatform.iOS)? CupertinoAlertDialog(title: title,content: subtitle,actions: <Widget>[close(ctx, "OK")])
        : AlertDialog(title: title,content: subtitle,actions: <Widget>[close(ctx, "OK")]);
      }
    );
  }

  FlatButton close(BuildContext ctx, String text){
    return FlatButton(
      onPressed: (()=> Navigator.pop(ctx)),
      child: Text(text,),
    );
  }

  Future<void> delete(BuildContext context,String id,String idFile,String titleDialog, String subtitleDialog) async{
    Text title = Text(titleDialog);
    Text subtitle = Text(subtitleDialog);
    return showDialog(context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx){
          return (Theme.of(context).platform==TargetPlatform.iOS)? CupertinoAlertDialog(title: title,content: subtitle,actions: <Widget>[close(ctx, "Annuler"),deleteBtn(ctx, "Supprimer",id,idFile)])
              : AlertDialog(title: title,content: subtitle,actions: <Widget>[close(ctx, "Annuler"),deleteBtn(ctx, "Supprimer",id,idFile)]);
        }
    );
  }

  FlatButton deleteBtn(BuildContext ctx, String text,String id,String idFile){
    return FlatButton(
      onPressed: (()=> {
        FireHelper().storage_posts.child(me.uid).child(idFile).delete(),
      
        FireHelper().fire_user.document(me.uid).collection("posts").document(id).delete(),
          Navigator.of(ctx).popUntil((route) => route.isFirst)}),
      child: Text(text,),
    );
  }

  Future<void> logOut(BuildContext context,String titleDialog, String subtitleDialog) async{
    Text title = Text(titleDialog);
    Text subtitle = Text(subtitleDialog);
    return showDialog(context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx){
          return (Theme.of(context).platform==TargetPlatform.iOS)? CupertinoAlertDialog(title: title,content: subtitle,actions: <Widget>[close(ctx, "Annuler"),logOutBtn(ctx, "Se déconnecter")])
              : AlertDialog(title: title,content: subtitle,actions: <Widget>[close(ctx, "Annuler"),logOutBtn(ctx, "Se déconnecter")]);
        }
    );
  }
  FlatButton logOutBtn(BuildContext ctx, String text){
    return FlatButton(
      onPressed: (()=> {
        Navigator.pop(ctx),
      FireHelper().logOut()
        }),
      child: Text(text,),
    );
  }

}