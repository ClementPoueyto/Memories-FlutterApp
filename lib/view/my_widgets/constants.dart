import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:memories/models/user.dart';
//ME
User me;
//colors
const Color white = const Color(0xFFFFFFFF);
const Color base = const Color(0xFFFFFFFF);
const Color primary = const Color(0xFFFFFFFF);
const Color secondary = const Color(0xFFFFFFFF);


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

