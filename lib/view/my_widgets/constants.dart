import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:memories/models/user.dart';
//ME
User me;
//colors
const Color white = const Color(0xFFFFFFFF);
const Color whiteShadow = const Color(0xFFF5F5F5);
const Color black = Colors.black;
const Color base = Colors.green;
const Color accent = const Color(0xFF00C853);

//Value

const double maxWidthImagePost= 1080.0;
const double maxHeightImagePost=1350.0;

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
String keyType ="type";
String keyRef = "ref";
String keySeen = "seen";
String keyDay="day";
String keyMonth="month";
String keyYear = "year";
String keyFullName="fullName";
String keyPseudo="pseudo";
String keyIdFrom="idFrom";
String keyIdTo = "idTo";
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

