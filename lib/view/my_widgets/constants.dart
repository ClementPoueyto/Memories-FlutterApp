import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:memories/models/notification.dart';
import 'package:memories/models/post.dart';
import 'package:memories/models/user.dart';
//ME
User me;

//POSTS
StreamController<List<Post>> postController = StreamController<List<Post>>.broadcast();
Stream<List<Post>> mePosts = postController.stream;
List<Post> myListPosts = List();

//FEED
List<Post> feedPostSave= List();
List<User> feedUserPostSave = List();

//NOTIFS
List<Notif> feedNotifSave = List();
List<User> feedUserNotifSave = List();

//colors
const Color white = const Color(0xFFFFFFFF);
const Color whiteShadow = const Color(0xFFF5F5F5);
const Color black = Colors.black;
const Color base = Colors.green;
const Color accent = const Color(0xFF00C853);

//Value

const double maxWidthImagePost= 1080.0;
const double maxHeightImagePost=1350.0;

//String urlApi ="https://memories.osc-fr1.scalingo.io/api/";
String urlApi ="http://192.168.1.69:9428/api/";

//keys
String keyFirstName = "firstName";
String keyLastName ="lastName";
String keyImageURL ="imageUrl";
String keyFollowers ="followers";
String keyFollowing ="following";
String keyUid = "uid";
String keyPost = "posts";
String keyPostId = "postID";
String keyTitle = "title";
String keyDescription = "description";
String keyDate = "date";
String keyLikes = "likes";
String keyComments = "comments";
String keyPosition = "position";
String keyIsPrivate= "isPrivate";
String keyAdress="adress";
String keyTextComment ="textComment";
String keyTextNotification = "textNotification";
String keyType ="types";
String keyRef = "ref";
String keySeen = "seen";
String keyDay="day";
String keyMonth="month";
String keyYear = "year";
String keyFullName="fullName";
String keyPseudo="pseudo";
String keyIdFrom="idFrom";
String keyIdTo = "idTo";
String keyId = "_id";
String keyEmail = "email";
String keyToken = "token";
String keyAdmin = "isAdmin";
//Icons

Icon homeIcon = Icon(Icons.home);
Icon addIcon = Icon(Icons.add);
Icon profileIcon = Icon(Icons.person);
Icon notificationIcon = Icon(Icons.notifications);
Icon searchIcon = Icon(Icons.search);
Icon burger = Icon(Icons.dehaze);
Icon place = Icon(Icons.place);
Icon postIcon = Icon(Icons.portrait);
Icon tagIcon = Icon(Icons.local_offer);
Icon settingsIcon = Icon(Icons.settings);
Icon closeIcon= Icon(Icons.close);
Icon likeIconFull =Icon(Icons.favorite);
Icon likeIcon =Icon(Icons.favorite_border);
Icon sendIcon = Icon(Icons.send);
Icon commentsIcon=Icon(Icons.comment);
Icon editIcon=Icon(Icons.mode_edit);
Icon backIcon=Icon(Icons.arrow_back);
Icon galleryIcon= Icon(Icons.photo);
Icon cameraIcon= Icon(Icons.photo_camera);


//enum

enum Months {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december
}



//Position

Position initializedPosition = Position(latitude: 0,longitude: 0);

//Assets

AssetImage searchImage = AssetImage("assets/image/glass.png");

String clientToken;