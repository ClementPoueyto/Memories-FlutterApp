import 'package:memories/view/my_material.dart';

///Model Commentaire de post

class Comment {
  String userId;
  String textComment;
  DateTime date;

  Comment(Map<String, dynamic> map) {
    userId = map[keyUid];
    textComment = map[keyTextComment];
    date = DateTime.fromMillisecondsSinceEpoch(map[keyDate]);
  }
}