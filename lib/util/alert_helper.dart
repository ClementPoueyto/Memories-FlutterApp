import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:memories/view/my_material.dart';

class AlertHelper{
  Future<void> error(BuildContext context, String error) async{
    Text title = Text("Erreur");
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
}