import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memories/view/my_material.dart';

///Model d'un utilisateur

class User {
  String uid;
  String firstName;
  String lastName;
  String fullName; // firstname + lastname
  String imageUrl; //url stockage image de profile
  String pseudo;
  bool isPrivate;
  List<String> followers; // abonnés
  List<String> following; //abonnements
  DocumentReference ref; // deprecated
  String documentId; //deprecated

  User(Map<String, dynamic> map){
    uid = map[keyId];
    isPrivate = map[keyIsPrivate];
    firstName = map[keyFirstName];
    lastName= map[keyLastName];
    fullName=map[keyFullName];
    following = List<String>.from(map[keyFollowing]);
    followers= List<String>.from(map[keyFollowers]);
    pseudo= map[keyPseudo];
    imageUrl = map[keyImageURL];
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
      keyIsPrivate : isPrivate,
    };
  }

}