import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

///Permet de manipuler les données d'une Carte
class MapHelper {
  Position position;

  ///Verifie si la permission du téléphone autorise la localisation
  Future<bool> isLocationEnable() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  ///Renvoie la position de l'utilisateur
  Future<Position> getPosition() async {
    if (await isLocationEnable()) {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      this.position = position;
      return position;
    }
  }
}
