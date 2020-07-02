import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:memories/models/post.dart';
import 'package:memories/util/api_post_helper.dart';
import 'package:memories/util/api_user_helper.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:launch_review/launch_review.dart';

/// Classe permettant d'ouvrir des boites de dialogues afin d'informer l'utilisateur

class AlertHelper {
  ///ALERT ERROR
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
      },
    );
  }

  /// bouton Close Alert error
  FlatButton close(BuildContext ctx, String text) {
    return FlatButton(
      onPressed: (() => Navigator.pop(ctx)),
      child: Text(
        text,
      ),
    );
  }

  ///ALERTE DE SUPPRESSION DE PUBLICATION
  Future<void> delete(BuildContext context, ValueNotifier<List<Post>> notifier, String id, String idFile,
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
                      deleteBtn(ctx, "Supprimer", id, idFile,notifier)
                    ])
              : AlertDialog(title: title, content: subtitle, actions: <Widget>[
                  close(ctx, "Annuler"),
                  deleteBtn(ctx, "Supprimer", id, idFile,notifier)
                ]);
        });
  }

  ///Bouton de validation de suppression
  FlatButton deleteBtn(
      BuildContext ctx, String text, String id, String idFile,ValueNotifier<List<Post>> notifier) {
    return FlatButton(
      onPressed: (() async => {
            ApiPostHelper().deletePost(id),
            notifyListener(notifier,id),
            if (idFile != null && idFile != ""){
                FireHelper().storage_posts.child(me.uid).child(idFile).delete(),
              },
            Navigator.of(ctx).popUntil((route) => route.isFirst)
          }),
      child: Text(
        text,
      ),
    );
  }

  notifyListener( ValueNotifier<List<Post>> notifier, String id){
    notifier.value.removeWhere((element) => element.id==id);
    notifier.notifyListeners();
  }

  ///ALERTE DE DECONNECTION
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

  ///Bouton validation de deconnection
  FlatButton logOutBtn(BuildContext ctx, String text) {
    return FlatButton(
      onPressed: (() => {ApiUserHelper().logOut(ctx)}),
      child: Text(
        text,
      ),
    );
  }

  ///ALERTE DE PUBLICATION DOUBLON LE MEME JOUR
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

  ///bouton de validation de réécriture du post du jour
  //TODO
  FlatButton overwriteBtn(
      BuildContext ctx, String text, Map<String, dynamic> map, String date) {
    return FlatButton(
      onPressed: (() => {
            /*FireHelper()
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
            )),*/
            Navigator.of(ctx).popUntil((route) => route.isFirst)
          }),
      child: Text(
        text,
      ),
    );
  }

  ///ALERTE NOUVELLE VERSION APPLICATION
  Future<void> newVersion(
      BuildContext context, String titleDialog, String subtitleDialog) async {
    Text title = Text(titleDialog);
    Text subtitle = Text(subtitleDialog);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                  title: title,
                  content: subtitle,
                  actions: <Widget>[newVersionBtn(ctx, "Télécharger")])
              : AlertDialog(
                  title: title,
                  content: subtitle,
                  actions: <Widget>[newVersionBtn(ctx, "Télécharger")]);
        });
  }

  ///Bouton de redirection vers Playstore
  FlatButton newVersionBtn(BuildContext ctx, String text) {
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
