import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/view/my_material.dart';

class User {
  String uid;
  String firstName;
  String lastName;
  String imageUrl;
  List<dynamic> followers;
  List<dynamic> following;
  List<dynamic> posts;
  DocumentReference ref;
  String documentId;

  User(DocumentSnapshot snapshot){
    print(snapshot.data);
    ref= snapshot.reference;
    documentId = snapshot.documentID;
    Map<String, dynamic> map = snapshot.data;
    uid = map[keyUid];
    firstName = map[keyFirstName];
    lastName= map[keyLastName];
    following = map[keyFollowing];
    followers= map[keyFollowers];
    imageUrl = map[keyImageURL];
    posts = map[keyPost];
  }

  Map<String, dynamic> toMap(){
    return {
      keyUid : uid,
      keyFirstName : firstName,
      keyLastName : lastName,
      keyImageURL : imageUrl,
      keyFollowing  :following,
      keyFollowers : followers,
      keyPost : posts,
    };
  }

}