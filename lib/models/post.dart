import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memories/view/my_material.dart';

class Post{

  DocumentReference ref;
  String documentId;
  String id;
  String title;
  String description;
  String userId;
  String imageUrl;
  int date;
  Position position;
  List<dynamic> tags;
  List<dynamic> likes;
  List<dynamic> comments;
  User user;

  Post(User user, DocumentSnapshot snapshot){
    ref = snapshot.reference;
    documentId = snapshot.documentID;
    user = user;
    Map<String, dynamic> map = snapshot.data;
    title = map[keyTitle];
    description = map[keyDescription];
    userId = map[keyUid];
    imageUrl = map[keyImageURL];
    date = map[keyDate];
    position = map[keyPosition];
    likes = map[keyLikes];
    comments = map[keyComments];
    id= map[keyPostId];

  }

  Map<String,dynamic> toMap(){
    Map<String, dynamic> map = {
      keyPostId:id,
      keyUid:userId,
      keyDate:date,
      keyLikes:likes,
      keyComments:comments,
      keyTitle:title,
    };
    if(description != null){
      map[keyDescription] = description;
    }
    if(position != null){
      map[keyPosition]= [position.altitude,position.longitude];
    }
    if(imageUrl!=null){
      map[keyImageURL] = imageUrl;
    }

    return map;
  }
}