import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/alert_helper.dart';
import 'package:memories/util/api_user_helper.dart';
import 'package:memories/util/date_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

///DEPRECIATED
///A ne plus utiliser car, plus de firebase
class FireHelper{

  final auth_instance = FirebaseAuth.instance;

  Future<FirebaseUser> signIn(String mail, String pwd, BuildContext context) async {
    FirebaseUser user;
    String errorMessage;
    try {
      final AuthResult result = (await auth_instance.signInWithEmailAndPassword(
          email: mail, password: pwd));
        user = result.user;

    }
    catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Votre adresse email n'existe pas.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Le mot de passe ne correspond pas.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "Cet utilisateur n'existe pas.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "Ce compte a été désactivé.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Nombre maximal de requêtes atteint. Merci de rééssayer plus tard.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Operation non autorisée.";
          break;
        default:
          errorMessage = "Désolé, une erreur inconnue s'est produite.";
      }
    } if (errorMessage != null) {
      AlertHelper().error(context,"Erreur d'authentification", errorMessage);
      return Future.error(errorMessage);
    }

    return user;
  }
  
  Future<FirebaseUser> createAccount(String mail, String pwd, String name, String surname,String pseudo, BuildContext context) async {
    FirebaseUser user;
    String errorMessage;
    try {
      final AuthResult result = (await auth_instance.createUserWithEmailAndPassword(email: mail, password: pwd));
      user = result.user;
      String id = user.uid;
      List<dynamic> followers=[id];
      List<dynamic> following=[];

      Map<String,dynamic> map={
        keyUid : id,
        keyFirstName :name,
        keyLastName:surname,
        keyPseudo:pseudo,
        keyFullName:name.toLowerCase() +surname.toLowerCase(),
        keyImageURL:"",
        keyFollowers:followers,
        keyFollowing : following,
        keyIsPrivate : false,
      };
      addUser(id, map);
    }
    catch(e){
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Votre adresse email n'existe pas.";
          break;

        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Nombre de tentatives maximal atteint. Merci de rééssayer plus tard.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Opération non autorisée.";
          break;
        default:
          errorMessage = "Cette adresse email est déjà utilisée";
      }
    } if (errorMessage != null) {
      AlertHelper().error(context,"Erreur d'authentification", errorMessage);
      return Future.error(errorMessage);
    }

    return user;
  }

  logOut()=> {auth_instance.signOut(),
  me=null
  };

  static final data_instance = Firestore.instance;
  final fire_user = data_instance.collection("users");
  final fire_app = data_instance.collection("app");

  Stream<QuerySnapshot> postsFrom(String uid) => fire_user.document(uid).collection("posts").where(keyIsPrivate, isEqualTo: false).snapshots();
  Stream<QuerySnapshot> myPostsFrom(String uid) => fire_user.document(uid).collection("posts").snapshots();

  addUser(String id, Map<String, dynamic> map){
    fire_user.document(id).setData(map);
  }

  addNotification(String from, String to, String text, DocumentReference ref, String type, DateTime date) {
    Map<String, dynamic> map = {
      keyTextNotification: text,
      keyType: type,
      keyRef: ref,
      keySeen: false,
      keyDate: date,
      keyIdFrom: from,
      keyIdTo : to,
      "content"  : text,
    };
    fire_user.document(to).collection("notifications").getDocuments().then((value) => {
        fire_user.document(to).collection("notifications").document(date.millisecondsSinceEpoch.toString()).setData(map)

    });
  }

  addFollow(User other){
    DateTime date =DateTime.now();
  if(me.following.contains(other.uid)){
      me.ref.updateData({keyFollowing: FieldValue.arrayRemove([other.uid])});
      other.ref.updateData({keyFollowers:FieldValue.arrayRemove([me.uid])});
    }
    else{
      me.ref.updateData({keyFollowing:FieldValue.arrayUnion([other.uid])});
      other.ref.updateData({keyFollowers:FieldValue.arrayUnion([me.uid])});
      addNotification(me.uid, other.uid, "${me.firstName} ${me.lastName} a commencé à vous suivre", me.ref, keyFollowers,date);

    }
  }

  modifiyUser(Map<String, dynamic> data) {
    fire_user.document(me.uid).updateData(data);
  }

  modifyPicture(File file)async {
    StorageReference ref = storage_user.child(me.uid);

    var finalised = await addImage(file, ref);
      Map<String, dynamic> data = {keyImageURL: finalised};
      return await ApiUserHelper().updateProfile(data);

  }

  addLike(Post post){
    DateTime date =DateTime.now();
    if(post.likes.contains(me.uid)){
      post.ref.updateData({keyLikes:FieldValue.arrayRemove([me.uid])});
    } else{
      post.ref.updateData({keyLikes:FieldValue.arrayUnion([me.uid])});
      if(me.uid!=post.userId) {

        addNotification(me.uid, post.userId,
            "${me.firstName} ${me.lastName} a aimé votre post", post.ref,
            keyLikes, date);

        /*var documentReference = Firestore.instance
            .collection('users')
            .document(post.userId)
            .collection("notifications")
            .document(date.millisecondsSinceEpoch.toString());

        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
            documentReference,
            {
              'idFrom': me.uid,
              'idTo': post.userId,
              'timestamp': date
                  .millisecondsSinceEpoch
                  .toString(),
              'content': "test",
              'type': "test"
            },
          );
        });*/

      }
    }
  }

  addComment(DocumentReference ref, String text, String postOwner) {
    DateTime date = DateTime.now();
    Map<dynamic, dynamic> map = {
      keyUid: me.uid,
      keyTextComment: text,
      keyDate: date,
    };
    ref.updateData({keyComments: FieldValue.arrayUnion([map])});
    if(postOwner!=me.uid) {
      addNotification(me.uid, postOwner,
          "${me.firstName} ${me.lastName} a commenté votre publication", ref,
          keyComments, date );
    }
  }


  Future<void> addpost(BuildContext context,String uid, String  title, String description, Position position, String adress ,File file,bool private){
    DateTime date =  DateTime.now();
    List<dynamic> likes = [];
    List<dynamic> comments = [];
    Map<String, dynamic> map = {
      keyUid : uid,
      keyTitle : title,
      keyLikes : likes,
      keyComments : comments,
      keyDate : date,
      keyIsPrivate : private,
    };
    if(description!=null&&description!=""){
      map[keyDescription] = description;
    }
    if(position!=null&&position!=""){
      map[keyPosition] = [position.latitude,position.longitude];
    }
    if(adress!=null&&adress!=""){
      map[keyAdress] = adress;
    }
    if(file!=null) {
      StorageReference ref = storage_posts.child(uid).child(DateHelper().myDate(date));
      addImage(file, ref).then((finalised) {
        String imageUrl = finalised;
        map[keyImageURL] = imageUrl;
        return addPostToDatabase(context, DateHelper().myDate(date), map);
      });
    }else{
     return addPostToDatabase(context, DateHelper().myDate(date), map);

    }
  }

  Future<bool> _checkIfAlreadyPosted(String uid,String date) async {
    final snapShot = await fire_user.document(uid).collection("posts").document(date).get();
    if (snapShot == null || !snapShot.exists) {
      return false;
    }
    else{
      return true;
    }
  }

  Future<void> addPostToDatabase(BuildContext context,String date,Map<String, dynamic> map)async {
     bool isPosted = await _checkIfAlreadyPosted(map[keyUid], date);
      if(isPosted==true){
        AlertHelper().overwrite(context, "Vous avez déjà publié aujourd'hui", "Voulez-vous supprimer l'ancienne publication ?", map, date);
      }
      else{
        Navigator.pop(context);
        return fire_user.document(map[keyUid]).collection("posts").document(date).setData(map).whenComplete(() =>
              Fluttertoast.showToast(
                  msg: "Publié avec succès",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  fontSize: 16.0
              )).catchError((e)=>Fluttertoast.showToast(
            msg: "erreur : "+e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0
        ));
      }

  }


  Future <void> modifyPost(String id,String uid, String  title, String description, Position position, String adress ,File file,String imageUrl,bool private,DateTime date,List<dynamic> likes,List<dynamic> comments)async {
    Map<String, dynamic> map = {
      keyUid : uid,
      keyTitle : title,
      keyLikes : likes,
      keyComments : comments,
      keyDate : date,
      keyIsPrivate : private,
      keyImageURL:imageUrl,
    };
    if(description!=null&&description!=""){
      map[keyDescription] = description;
    }
    if(position!=null&&position!=""){
      map[keyPosition] = [position.latitude,position.longitude];
    }
    if(adress!=null&&adress!=""){
      map[keyAdress] = adress;
    }
    StorageReference ref = storage_posts.child(uid).child(DateHelper().myDate(date));
    if(file!=null) {
       await addImage(file, ref).then((finalised) {
        String imageUrl = finalised;
        map[keyImageURL] = imageUrl;
        return fire_user.document(uid).collection("posts").document(id).setData(map);

      });
    }
    else if(file==null&&(imageUrl==null||imageUrl=="")){
      ref.getDownloadURL().then((value) => {
        if(value!=null){
          ref.delete().then((value) => null).catchError((e){})
    }
      }).catchError((e)=>print(e));
      map[keyImageURL]="";
      return fire_user.document(uid).collection("posts").document(id).setData(map);
    }
    else{
      return fire_user.document(uid).collection("posts").document(id).setData(map);
    }



  }

  //storage

static final storage_instance = FirebaseStorage.instance.ref();
  final storage_user = storage_instance.child("users");
  final storage_posts = storage_instance.child("posts");

  Future<String> addImage(File file, StorageReference ref) async{
    StorageUploadTask task = ref.putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;
    String urlString = await snapshot.ref.getDownloadURL();
    return urlString;
  }

}