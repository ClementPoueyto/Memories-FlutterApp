import 'package:memories/view/my_material.dart';

///Model CLient

class Client {
  String id;
  String email;
  bool isAdmin;
  String token; //token de connection et d'authentification

  Client(Map<String, dynamic> map) {
    id = map[keyId];
    email = map[keyEmail];
    isAdmin = map[keyAdmin];
    token = map[keyToken];
  }
}