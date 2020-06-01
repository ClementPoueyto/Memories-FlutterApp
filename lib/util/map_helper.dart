import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapHelper{

  Position position;

  Future<bool> isLocationEnable ()async {
    var status = await Permission.location.request();
    if(status==PermissionStatus.granted){
    return true;
    }
    else{
      return false;
    }
  }

  Future<Position> getPosition()async{
    if(await isLocationEnable()) {
      Position position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      this.position = position;
      return position;
    }
  }






}