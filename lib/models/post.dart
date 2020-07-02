import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memories/view/my_material.dart';

///Model d'une publication

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
  List<String> tags; // fonctionnalité à developper
  List<String> likes;
  List<dynamic> comments;
  String adress;
  bool isPrivate;

  Post(Map<String, dynamic> map){
    title = map[keyTitle];
    description = map[keyDescription];
    imageUrl = map[keyImageURL];
    date = DateTime.fromMillisecondsSinceEpoch(map[keyDate]);
    position = map[keyPosition]!=null&&map[keyPosition]['latitude']!=null?Position(latitude: map[keyPosition]['latitude'].toDouble(), longitude: map[keyPosition]['longitude'].toDouble()):null;
    likes = List<String>.from(map[keyLikes]);
    comments = List<dynamic>.from(map[keyComments]);
    id= map[keyId];
    userId=map[keyUid];
    adress=map[keyAdress];
    isPrivate=map[keyIsPrivate];
  }

  Map<String,dynamic> toMap(){
    Map<String, dynamic> map = {
      keyPostId:id,
      keyDate:date,
      keyLikes:likes,
      keyComments:comments,
      keyTitle:title,
      keyUid:userId,
      keyIsPrivate:isPrivate,
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