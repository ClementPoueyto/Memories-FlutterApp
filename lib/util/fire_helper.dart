import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:memories/view/my_material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
class FireHelper{

  final auth_instance = FirebaseAuth.instance;

  Future<FirebaseUser> signIn(String mail, String pwd) async {
    final AuthResult result= (await auth_instance.signInWithEmailAndPassword(email: mail, password: pwd));
    final FirebaseUser user = result.user;
    return user;
  }
  
  Future<FirebaseUser> createAccount(String mail, String pwd, String name, String surname) async {
    final AuthResult result = (await auth_instance.createUserWithEmailAndPassword(email: mail, password: pwd)) ;
    final FirebaseUser user = result.user;
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
    return user;
  }

  logOut()=> auth_instance.signOut();

  static final data_instance = Firestore.instance;
  final fire_user = data_instance.collection("users");

  Stream<QuerySnapshot> postsFrom(String uid) => fire_user.document(uid).collection("posts").snapshots();

  addUser(String id, Map<String, dynamic> map){
    fire_user.document(id).setData(map);
  }

  addpost(String uid, String  title, String description, Position position, File file){
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
    if(file!=null) {
      print(uid);
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