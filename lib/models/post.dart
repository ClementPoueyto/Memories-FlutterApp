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
  DateTime date;
  Position position;
  List<dynamic> tags;
  List<dynamic> likes;
  List<dynamic> comments;
  String adress;

  Post(DocumentSnapshot snapshot){
    ref = snapshot.reference;
    documentId = snapshot.documentID;
    Map<String, dynamic> map = snapshot.data;
    title = map[keyTitle];
    description = map[keyDescription];
    imageUrl = map[keyImageURL];
    date = map[keyDate].toDate();
    position = Position(latitude: map[keyPosition][0], longitude: map[keyPosition][1]);
    likes = map[keyLikes];
    comments = map[keyComments];
    id= map[keyPostId];
    userId=map[keyUid];
    adress=map[keyAdress];

  }

  Map<String,dynamic> toMap(){
    Map<String, dynamic> map = {
      keyPostId:id,
      keyDate:date,
      keyLikes:likes,
      keyComments:comments,
      keyTitle:title,
      keyUid:userId,
    };
    if(description != null){
      map[keyDescription] = description;
    }
    if(position != null){
      map[keyPosition]= [position.latitude,position.longitude];
    }
    if(adress !=null){
      map[keyAdress]=adress;
    }
    if(imageUrl!=null){
      map[keyImageURL] = imageUrl;
    }

    return map;
  }
}