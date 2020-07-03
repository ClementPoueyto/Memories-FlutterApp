import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memories/models/comment.dart';
import 'package:memories/models/post.dart';
import 'package:memories/util/alert_helper.dart';
import 'package:memories/view/my_material.dart';

///Appel API POST

class ApiPostHelper {



  ///Renvoie tous les posts de l'utilisateur connecté
  ///@required Token
  Future<List<Post>> getMyPosts() async {
    List<Post> myPosts = List();
    String errorMessage;
    try {
      final result = (await http.get(
        urlApi + "posts/myPosts",
        headers: {
          HttpHeaders.authorizationHeader: clientToken,
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8'
        },
      ));

      List<dynamic> posts = jsonDecode(result.body);

      posts.forEach((element) {
        myPosts.add(Post(element));
      });

      return myPosts;
    } catch (error) {
      errorMessage = error.toString();
      print("error getMyPosts : "+errorMessage);
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  ///Renvoie un post par son _id
  Future<Post> getPostById(String idPost) async {
    Map<String, dynamic> post;
    String errorMessage;
    try {
      final result = (await http.get(
        urlApi + "posts/" + idPost,
        headers: {
          HttpHeaders.authorizationHeader: clientToken,
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8'
        },
      ));
      post = jsonDecode(result.body);
      return Post(post);

    } catch (error) {
      errorMessage = error.toString();
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  ///Renvoie tous les posts publics d'un utilisateur par son uid
  ///@required Token
  Future<List<Post>> getPostFromId(String uid) async {
    List<dynamic> posts;
    String errorMessage;
    try {
      final result = (await http.get(
        urlApi + "posts/postsFrom/" + uid,
        headers: {
          HttpHeaders.authorizationHeader: clientToken,
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8'
        },
      ));
      posts = jsonDecode(result.body);
      List<Post> myPosts = List();
      posts.forEach((element) {
        myPosts.add(Post(element));
      });
      return myPosts;
    } catch (error) {
      errorMessage = error.toString();
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  ///Renvoie tous les posts publics d'une liste d'utilisateur (abonnement)
  Future<List<Post>> getMyFeed(List<String> usersId) async {
    List<Post> posts = List();
    await Future.forEach(usersId, (element) async {
      List<Post> usersPosts = await getPostFromId(element);
      if (usersPosts != null && usersPosts.length > 0) {
        usersPosts.forEach((element) {
          posts.add(element);
        });
      }
    });
    return posts;
  }

  ///Publie le post dans la base de donnée
  ///@required Token
  Future<Post> postMyPost(BuildContext context, Map<String, dynamic> post) async {
    String errorMessage;
    try {
      final result = (await http.post(urlApi + "posts/",
          headers: {
            "Accept": "application/json",
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: clientToken
          },
          body: jsonEncode(post)));
      print(jsonDecode(result.body));
      if (result.statusCode == 201) {
        Post postToAdd = Post(jsonDecode(result.body));
        //Met a jour les données partagées
        List<Post> list = myListPosts;
        list.add(postToAdd);
        postController.add(list);
        print("here"+postToAdd.toString());
        return postToAdd;
      }
    } catch (error) {
      errorMessage = error.toString();
      print(errorMessage);
    }
    if (errorMessage != null) {
      AlertHelper().error(context, "Erreur d'authentification", errorMessage);
      return Future.error(errorMessage);
    }
  }

  ///Modifie un post avec les elements passés en paramètre
  ///@required Token
  Future<Post> updateMyPost(
      BuildContext context, Map<String, dynamic> post, String id) async {
    String errorMessage;
    try {
      final result = (await http.put(urlApi + "posts/" + id,
          headers: {
            "Accept": "application/json",
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: clientToken
          },
          body: jsonEncode(post)));
      if (result.statusCode == 200) {
        List<Post> list = myListPosts;
        list.removeWhere((element) => element.id == id);
        list.add(Post(jsonDecode(result.body)));
        postController.add(list);
        return Post(jsonDecode(result.body));
      }
    } catch (error) {
      errorMessage = error.toString();
      print("errror update Post : " + errorMessage);
    }
    if (errorMessage != null) {
      AlertHelper().error(context, "Erreur d'authentification", errorMessage);
      return Future.error(errorMessage);
    }
  }

  ///Supprime le post de la BDD
  ///@required Token
  Future<Post> deletePost(String idPost) async {
    String errorMessage;
    try {
      final result = (await http.delete(
        urlApi + "posts/" + idPost,
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: clientToken
        },
      ));
      if (result.statusCode == 200) {
        List<Post> list = myListPosts;
        list.removeWhere((element) => element.id == idPost);
        postController.add(list);
        return Post(jsonDecode(result.body));
      }
    } catch (error) {
      errorMessage = error.toString();
      print("errror delete Post : " + errorMessage);
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  ///Incrémente le compteur de like d'un post
  ///@required Token
  Future<Post> likePost(String idPost) async {
    String errorMessage;
    try {
      final result = (await http.put(
        urlApi + "posts/" + idPost + "/like",
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: clientToken
        },
      ));

      return Post(jsonDecode(result.body));
    } catch (error) {
      errorMessage = error.toString();
      print("errror like post : " + errorMessage);
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  ///Ajoute un commentaire à un post
  ///@required Token
  Future <Comment> addComment(Map<String, dynamic> map, String idPost) async {
    String errorMessage;
    try {
      final result = (await http.post(urlApi + "posts/" + idPost + "/comments",
          headers: {
            "Accept": "application/json",
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: clientToken
          },
          body: jsonEncode(map)));
      Comment commentToAdd = Comment(jsonDecode(result.body));

      return commentToAdd;
    } catch (error) {
      errorMessage = error.toString();
      print("errror add Comment : " + errorMessage);
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }
}
