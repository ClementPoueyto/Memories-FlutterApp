import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/view/my_material.dart';

class User {
  String uid;
  String firstName;
  String lastName;
  String fullName;
  String imageUrl;
  String pseudo;
  bool isPrivate;
  List<dynamic> followers;
  List<dynamic> following;
  List<dynamic> posts;
  DocumentReference ref;
  String documentId;

  User(DocumentSnapshot snapshot){
    ref= snapshot.reference;
    documentId = snapshot.documentID;
    Map<String, dynamic> map = snapshot.data;
    uid = map[keyUid];
    isPrivate = map[keyIsPrivate];
    firstName = map[keyFirstName];
    lastName= map[keyLastName];
    fullName=map[keyFullName];
    following = map[keyFollowing];
    followers= map[keyFollowers];
    pseudo= map[keyPseudo];
    imageUrl = map[keyImageURL];
    posts = map[keyPost];
  }

  Map<String, dynamic> toMap(){
    return {
      keyUid : uid,
      keyFirstName : firstName,
      keyLastName : lastName,
      keyFullName : firstName+lastName,
      keyImageURL : imageUrl,
      keyFollowing  :following,
      keyPseudo : pseudo,
      keyFollowers : followers,
      keyPost : posts,
      keyIsPrivate : isPrivate,
    };
  }

}