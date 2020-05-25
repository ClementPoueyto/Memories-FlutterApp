import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';


class MyMap extends StatefulWidget {
  Future<Position> initFuturePosition;
  Position initPosition;
  List<Marker> listMarkers;


  MyMap(this.initFuturePosition,this.initPosition,this.listMarkers);
  
  @override
  _MyMapState createState() => new _MyMapState();
}

class _MyMapState extends State<MyMap> {

  MapController mapController = MapController();
  List<Marker> markersList;
  @override 
  void initState() {
    super.initState();
    this.markersList=widget.listMarkers;
    widget.initFuturePosition.then((value) => {
      mapController.move(LatLng(value.latitude, value.longitude) , 12),
      addMarker(Position(latitude: value.latitude, longitude: value.longitude))
    });
  }
  
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new FlutterMap(
          mapController: mapController,
            options: new MapOptions(
              interactive: false,
                center: new LatLng(widget.initPosition.latitude, widget.initPosition.longitude), minZoom: 10.0),
            layers: [
              new TileLayerOptions(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']
              ),
              new MarkerLayerOptions(

                  markers: markersList)
            ]));
  }

  void addMarker(Position position){
    this.markersList.add (new Marker(
        width: 45.0,
        height: 45.0,
        point: new LatLng(position.latitude, position.longitude),
        builder: (context) => new Container(
          child: IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.blue,
            iconSize: 45.0,
            onPressed: () {
              print('Marker tapped');
            },
          ),
        )));
  }
}
