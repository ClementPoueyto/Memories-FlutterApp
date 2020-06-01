import 'package:memories/view/my_material.dart';
import 'package:memories/util/date_helper.dart';

class Comment {
  String userId;
  String textComment;
  String date;

  Comment(Map<dynamic, dynamic> map) {
    userId = map[keyUid];
    textComment = map[keyTextComment];
    date = DateHelper().myDate(map[keyDate].toDate());
  }
}