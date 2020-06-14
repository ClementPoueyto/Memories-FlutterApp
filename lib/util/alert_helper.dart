import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:launch_review/launch_review.dart';


class AlertHelper {
  //ALERT ERROR
  Future<void> error(
      BuildContext context, String errorTitle, String error) async {
    Text title = Text(errorTitle);
    Text subtitle = Text(error);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                  title: title,
                  content: subtitle,
                  actions: <Widget>[close(ctx, "OK")])
              : AlertDialog(
                  title: title,
                  content: subtitle,
                  actions: <Widget>[close(ctx, "OK")]);
        });
  }

  FlatButton close(BuildContext ctx, String text) {
    return FlatButton(
      onPressed: (() => Navigator.pop(ctx)),
      child: Text(
        text,
      ),
    );
  }

  //ALERTE DE SUPPRESSION DE PUBLICATION

  Future<void> delete(BuildContext context, String id, String idFile,
      String titleDialog, String subtitleDialog) async {
    Text title = Text(titleDialog);
    Text subtitle = Text(subtitleDialog);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                  title: title,
                  content: subtitle,
                  actions: <Widget>[
                      close(ctx, "Annuler"),
                      deleteBtn(ctx, "Supprimer", id, idFile)
                    ])
              : AlertDialog(title: title, content: subtitle, actions: <Widget>[
                  close(ctx, "Annuler"),
                  deleteBtn(ctx, "Supprimer", id, idFile)
                ]);
        });
  }

  FlatButton deleteBtn(
      BuildContext ctx, String text, String id, String idFile) {
    return FlatButton(
      onPressed: (() => {
            FireHelper().storage_posts.child(me.uid).child(idFile).delete(),
            FireHelper()
                .fire_user
                .document(me.uid)
                .collection("posts")
                .document(id)
                .delete(),
            Navigator.of(ctx).popUntil((route) => route.isFirst)
          }),
      child: Text(
        text,
      ),
    );
  }

  //ALERTE DE DECONNECTION

  Future<void> logOut(
      BuildContext context, String titleDialog, String subtitleDialog) async {
    Text title = Text(titleDialog);
    Text subtitle = Text(subtitleDialog);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                  title: title,
                  content: subtitle,
                  actions: <Widget>[
                      close(ctx, "Annuler"),
                      logOutBtn(ctx, "Se déconnecter")
                    ])
              : AlertDialog(title: title, content: subtitle, actions: <Widget>[
                  close(ctx, "Annuler"),
                  logOutBtn(ctx, "Se déconnecter")
                ]);
        });
  }

  FlatButton logOutBtn(BuildContext ctx, String text) {
    return FlatButton(
      onPressed: (() => {Navigator.pop(ctx), FireHelper().logOut()}),
      child: Text(
        text,
      ),
    );
  }

  //ALERTE DE PUBLICATION DOUBLON LE MEME JOUR

  Future<void> overwrite(BuildContext context, String titleDialog,
      String subtitleDialog, Map<String, dynamic> map, String date) async {
    Text title = Text(titleDialog);
    Text subtitle = Text(subtitleDialog);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                  title: title,
                  content: subtitle,
                  actions: <Widget>[
                      close(ctx, "Annuler"),
                      overwriteBtn(ctx, "Ecraser publication", map, date)
                    ])
              : AlertDialog(title: title, content: subtitle, actions: <Widget>[
                  close(ctx, "Annuler"),
                  overwriteBtn(ctx, "Ecraser publication", map, date)
                ]);
        });
  }

  FlatButton overwriteBtn(
      BuildContext ctx, String text, Map<String, dynamic> map, String date) {
    return FlatButton(
      onPressed: (() => {
            FireHelper()
                .fire_user
                .document(map[keyUid])
                .collection("posts")
                .document(date)
                .setData(map)
                .whenComplete(() =>
                    {
                      Fluttertoast.showToast(
                          msg: "Publié avec succès",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          fontSize: 16.0
                      )
                    }).catchError((e)=> Fluttertoast.showToast(
                msg: "erreur : "+e.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                fontSize: 16.0
            )),
        Navigator.of(ctx).popUntil((route) => route.isFirst)

          }),
      child: Text(
        text,
      ),
    );
  }

  //ALERTE NOUVELLE VERSION APPLICATION

  Future<void> newVersion(BuildContext context, String titleDialog,
      String subtitleDialog) async {
    Text title = Text(titleDialog);
    Text subtitle = Text(subtitleDialog);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
              title: title,
              content: subtitle,
              actions: <Widget>[
                newVersionBtn(ctx, "Télécharger")
              ])
              : AlertDialog(title: title, content: subtitle, actions: <Widget>[
            newVersionBtn(ctx, "Télécharger")
          ]);
        });
  }

  FlatButton newVersionBtn(
      BuildContext ctx, String text) {
    return FlatButton(
      onPressed: (() => {
        LaunchReview.launch(
          androidAppId: "fr.mencelt.memories",

        )
      }),
      child: Text(
        text,
      ),
    );
  }

}
