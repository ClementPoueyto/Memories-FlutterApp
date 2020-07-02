import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memories/main.dart';
import 'package:memories/models/client.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/alert_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Appel API USER

class ApiUserHelper {
  ///Verifie l'etat du serveur
  Future<String> getStatus() async {
    final response = await http
        .get(urlApi + "/status", headers: {"Accept": "application/json"});
    return jsonDecode(response.body);
  }

  ///Permet de se connecter et Renvoie un Client
  ///genere un Token si success
  Future<Client> logIn(String mail, String pwd, BuildContext context) async {
    Client client;
    String errorMessage;
    try {
      final result = (await http.post(urlApi + "auth/login",
          headers: {
            "Accept": "application/json",
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            'email': mail,
            'password': pwd,
          })));
      client = Client(jsonDecode(result.body));
      clientToken = client.token;
    } catch (error) {
      errorMessage = error.toString();
    }
    if (errorMessage != null) {
      AlertHelper().error(context, "Erreur d'authentification", errorMessage);
      return Future.error(errorMessage);
    }
    return client;
  }

  ///Permet de s'inscrire et Renvoie un User
  Future<User> signIn(String mail, String pwd, String firstName,
      String lastName, String pseudo, BuildContext context) async {
    User user;
    String errorMessage;
    try {
      final result = (await http.post(urlApi + "auth/signin",
          headers: {
            "Accept": "application/json",
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            'email': mail,
            'password': pwd,
            'lastName': lastName,
            'firstName': firstName,
            'pseudo': pseudo
          })));
      return User(jsonDecode(result.body));
    } catch (error) {
      errorMessage = error.toString();
      print(errorMessage.toString());
    }
    if (errorMessage != null) {
      AlertHelper().error(context, "Erreur d'authentification", errorMessage);
      return Future.error(errorMessage);
    }

    return user;
  }

  ///Renvoie l'utilisateur connecté (User data)
  ///@required Token
  Future<User> getMyProfile() async {
    Map<String, dynamic> user;
    String errorMessage;
    try {
      final result = (await http.get(
        urlApi + "users/me",
        headers: {
          HttpHeaders.authorizationHeader: clientToken,
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8'
        },
      ));
      user = jsonDecode(result.body);
    } catch (error) {
      errorMessage = error.toString();
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
    //met a jour les données partagées de l'utilisateur dans l'app
    me = User(user);
    return User(user);
  }

  ///Renvoie une liste d'utilisateur (User) des abonnés
  ///@required Token
  Future<List<User>> getMyFollowers() async {
    List<dynamic> users;
    String errorMessage;
    try {
      final result = (await http.get(
        urlApi + "users/myFollowers",
        headers: {
          HttpHeaders.authorizationHeader: clientToken,
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8'
        },
      ));
      users = jsonDecode(result.body);
    } catch (error) {
      errorMessage = error.toString();
      print("error get followers : " + errorMessage.toString());
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
    List<User> usersList = List();
    users.forEach((element) {
      usersList.add(User(element));
    });
    return usersList;
  }

  ///Renvoie une liste d'utilisateur (User) des abonnements
  ///@required Token
  Future<List<User>> getMyFollowing() async {
    List<dynamic> users;
    String errorMessage;
    try {
      final result = (await http.get(
        urlApi + "users/myFollowing",
        headers: {
          HttpHeaders.authorizationHeader: clientToken,
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8'
        },
      ));
      users = jsonDecode(result.body);
    } catch (error) {
      errorMessage = error.toString();
      print("error get following" + errorMessage.toString());
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
    List<User> usersList = List();
    users.forEach((element) {
      usersList.add(User(element));
    });
    return usersList;
  }

  ///Renvoie les données d'un utilisateur (User) par son id si celui-ci est public
  Future<User> getUserById(String id) async {
    Map<String, dynamic> user;
    String errorMessage;
    try {
      final result = (await http.get(
        urlApi + "users/" + id,
        headers: {
          HttpHeaders.authorizationHeader: clientToken,
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8'
        },
      ));
      user = jsonDecode(result.body);
    } catch (error) {
      errorMessage = error.toString();
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
    return User(user);
  }

  ///Genere un nouveau token de connection
  ///@required token
  Future getNewToken(String token) async {
    String errorMessage;
    try {
      final result = (await http.get(
        urlApi + "auth/token",
        headers: {HttpHeaders.authorizationHeader: token},
      ));
      final res = jsonDecode(result.body);
      clientToken = res['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', clientToken);

      return res;
    } catch (error) {
      errorMessage = error.toString();
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  ///Permet de se deconnecter, supprime le token de connection, reinitialise les données partagées
  Future logOut(BuildContext context) async {
    clientToken = null;
    me = null;
    notifsList = List();
    userNotif = List();
    myFeedPost = List();
    myFeedUser = List();
    myListPosts = List();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', clientToken);
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  ///Update User, Permet de follow un User
  ///@required Token, return User connecté
  Future<User> follow(String idToFollow) async {
    String errorMessage;
    try {
      final result = (await http.put(
        urlApi + "users/follow/" + idToFollow,
        headers: {HttpHeaders.authorizationHeader: clientToken},
      ));
      final res = jsonDecode(result.body);
      return User(res);
    } catch (error) {
      print(errorMessage);
    }
    if (errorMessage != null) {
      return me;
    }
  }

  ///Permet de rechercher un utilisateur par son pseudo
  ///@required Token
  searchUser(String pseudo) async {
    List<dynamic> user;
    String errorMessage;
    try {
      final result = (await http.get(
        urlApi + "users/search/" + pseudo,
        headers: {
          HttpHeaders.authorizationHeader: clientToken,
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8'
        },
      ));
      user = jsonDecode(result.body);
    } catch (error) {
      errorMessage = error.toString();
      print("error search user : " + errorMessage.toString());
    }
    if (errorMessage != null) {
      return;
    }

    return user;
  }

  ///Permet de mettre a jour le profil de l'utilisateur connecté
  ///@required Token
  Future<User> updateProfile(Map<String, dynamic> profile) async {
    Map<String, dynamic> user;
    String errorMessage;
    try {
      final result = (await http.put(
        urlApi + "users/me",
        headers: {
          HttpHeaders.authorizationHeader: clientToken,
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(profile),
      ));
      user = jsonDecode(result.body);
      me = User(user);
      return User(user);
    } catch (error) {
      errorMessage = error.toString();
      print(errorMessage.toString());
    }
    if (errorMessage != null) {
      return Future.value(User(profile));
    }
    return Future.value(User(profile));
  }

  streamTest() async {
    String errorMessage;
    try {
      var result = (await http.get(
        urlApi + "users/test/",
        headers: {HttpHeaders.authorizationHeader: clientToken},
      ));
      var res = jsonDecode(result.body);
    } catch (error) {
      print(errorMessage);
    }
    if (errorMessage != null) {}
  }
}
