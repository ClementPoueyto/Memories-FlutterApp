import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/alert_helper.dart';
import 'package:memories/util/date_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
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
  
  Future<FirebaseUser> createAccount(String mail, String pwd, String name, String surname, BuildContext context) async {
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
        keyFullName:name +surname.toLowerCase(),
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
  final fire_notif = data_instance.collection("notifications");

  Stream<QuerySnapshot> postsFrom(String uid) => fire_user.document(uid).collection("posts").where(keyIsPrivate, isEqualTo: false).snapshots();
  Stream<QuerySnapshot> myPostsFrom(String uid) => fire_user.document(uid).collection("posts").snapshots();

  addUser(String id, Map<String, dynamic> map){
    fire_user.document(id).setData(map);
  }

  addNotification(String from, String to, String text, DocumentReference ref, String type) {
    Map<String, dynamic> map = {
      keyUid: from,
      keyTextNotification: text,
      keyType: type,
      keyRef: ref,
      keySeen: false,
      keyDate: DateTime.now(),
    };
    fire_user.document(to).collection("notifications").getDocuments().then((value) => {
        fire_user.document(to).collection("notifications").add(map)

    });
  }

  addFollow(User other){
    if(me.following.contains(other.uid)){
      me.ref.updateData({keyFollowing: FieldValue.arrayRemove([other.uid])});
      other.ref.updateData({keyFollowers:FieldValue.arrayRemove([me.uid])});
    }
    else{
      me.ref.updateData({keyFollowing:FieldValue.arrayUnion([other.uid])});
      other.ref.updateData({keyFollowers:FieldValue.arrayUnion([me.uid])});
      addNotification(me.uid, other.uid, "${me.firstName} ${me.lastName} a commencé à vous suivre", me.ref, keyFollowers);

    }
  }

  modifiyUser(Map<String, dynamic> data) {
    fire_user.document(me.uid).updateData(data);
  }

  modifyPicture(File file){
    StorageReference ref = storage_user.child(me.uid);
    addImage(file, ref).then((finalised) {
      Map<String, dynamic> data = {keyImageURL: finalised};
      modifiyUser(data);
    });
  }

  addLike(Post post){
    if(post.likes.contains(me.uid)){
      post.ref.updateData({keyLikes:FieldValue.arrayRemove([me.uid])});
    } else{
      post.ref.updateData({keyLikes:FieldValue.arrayUnion([me.uid])});
      addNotification(me.uid, post.userId, "${me.firstName} ${me.lastName} a aimé votre post", post.ref, keyLikes);
    }
  }

  addComment(DocumentReference ref, String text, String postOwner) {
    Map<dynamic, dynamic> map = {
      keyUid: me.uid,
      keyTextComment: text,
      keyDate: DateTime.now(),
    };
    ref.updateData({keyComments: FieldValue.arrayUnion([map])});
    addNotification(me.uid, postOwner, "${me.firstName} ${me.lastName} a commenté votre post", ref, keyComments);
  }


  addpost(String uid, String  title, String description, Position position, String adress ,File file,bool private){
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
        fire_user.document(uid).collection("posts").document(DateHelper().myDate(date)).setData(map);
      });
    }else{
      fire_user.document(uid).collection("posts").document(DateHelper().myDate(date)).setData(map);
    }
  }


  modifyPost(String id,String uid, String  title, String description, Position position, String adress ,File file,String imageUrl,bool private,DateTime date,List<dynamic> likes,List<dynamic> comments){
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
      addImage(file, ref).then((finalised) {
        String imageUrl = finalised;
        map[keyImageURL] = imageUrl;
        fire_user.document(uid).collection("posts").document(id).setData(map);

      });
    }
    else if(file==null&&(imageUrl==null||imageUrl=="")){
      ref.delete().then((value) => null).catchError((e){});
      map[keyImageURL]="";
      fire_user.document(uid).collection("posts").document(id).setData(map);
    }
    else{
      fire_user.document(uid).collection("posts").document(id).setData(map);
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