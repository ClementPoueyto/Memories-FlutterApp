import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memories/view/my_material.dart';

///Appel API Version autorisé
///non connecté à la base de donnée

class ApiVersionHelper {
  ///Renvoie une liste des versions autorisées
  Future<List<dynamic>> getAllowedVersions() async {
    List<dynamic> versions = List();
    String errorMessage;
    try {
      final result = (await http.get(
        urlApi + "version/",
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8'
        },
      ));

      versions = jsonDecode(result.body);
      print(versions);
      return versions;
    } catch (error) {
      errorMessage = error.toString();
      print(errorMessage);
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }
}
