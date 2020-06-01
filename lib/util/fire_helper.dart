import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/alert_helper.dart';
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
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
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
      List<dynamic> followers=[];
      List<dynamic> following=[id];

      Map<String,dynamic> map={
        keyUid : id,
        keyFirstName :name,
        keyLastName:surname,
        keyImageURL:"",
        keyFollowers:followers,
        keyFollowing : following,
      };
      addUser(id, map);
    }
    catch(e){
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;

        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened. Or this mail has already been taken.";
      }
    } if (errorMessage != null) {
      AlertHelper().error(context,"Erreur d'authentification", errorMessage);
      return Future.error(errorMessage);
    }

    return user;
  }

  logOut()=> auth_instance.signOut();

  static final data_instance = Firestore.instance;
  final fire_user = data_instance.collection("users");
  final fire_notif = data_instance.collection("notifications");

  Stream<QuerySnapshot> postsFrom(String uid) => fire_user.document(uid).collection("posts").snapshots();

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
    fire_user.document(to).collection("notifications").add(map);
  }

  addFollow(User other){
    if(me.following.contains(other.uid)){
      me.ref.updateData({keyFollowing: FieldValue.arrayRemove([other.uid])});
      other.ref.updateData({keyFollowers:FieldValue.arrayRemove([me.uid])});
    }
    else{
      me.ref.updateData({keyFollowing:FieldValue.arrayUnion([other.uid])});
      other.ref.updateData({keyFollowers:FieldValue.arrayUnion([me.uid])});
    }
  }

  addLike(Post post){
    if(post.likes.contains(me.uid)){
      post.ref.updateData({keyLikes:FieldValue.arrayRemove([me.uid])});
    } else{
      post.ref.updateData({keyLikes:FieldValue.arrayUnion([me.uid])});
      addNotification(me.uid, post.userId, "${me.lastName} ${me.firstName} a aimé votre post", post.ref, keyLikes);

    }
  }

  addComment(DocumentReference ref, String text, String postOwner) {
    Map<dynamic, dynamic> map = {
      keyUid: me.uid,
      keyTextComment: text,
      keyDate: DateTime.now(),
    };
    ref.updateData({keyComments: FieldValue.arrayUnion([map])});
  }


  addpost(String uid, String  title, String description, Position position, String adress ,File file){
    DateTime date =  DateTime.now();
    List<dynamic> likes = [];
    List<dynamic> comments = [];
    Map<String, dynamic> map = {
      keyUid : uid,
      keyTitle : title,
      keyLikes : likes,
      keyComments : comments,
      keyDate : date,
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
      StorageReference ref = storage_posts.child(uid).child(date.toString());
      addImage(file, ref).then((finalised) {
        String imageUrl = finalised;
        map[keyImageURL] = imageUrl;
        fire_user.document(uid).collection("posts").document().setData(map);
      });
    }else{
      fire_user.document(uid).collection("posts").document().setData(map);
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