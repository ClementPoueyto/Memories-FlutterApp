import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:memories/models/post.dart';
import 'package:memories/util/map_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class ProfileMapPage extends StatefulWidget {
  final Map<Months, List<Post>> listPosts;

  ProfileMapPage(this.listPosts);

  _ProfileMapState createState() => _ProfileMapState();
}

class _ProfileMapState extends State<ProfileMapPage> {
  Future<Position> _userPosition;
  int currentMonth = DateTime.now().month;
  List<Marker> markers=[];
  MapController mapController;
  bool loadMap = false;
  @override
  void initState() {
    super.initState();
    mapController= new MapController();
    mapController.onReady.then((value) =>  updateMarkers());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.15 - kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MyIconButton(
                icon: Icon(Icons.chevron_left),
                function: () {
                  setState(() {
                    if (currentMonth == 1) {
                      currentMonth = 12;
                    } else {
                      currentMonth -= 1;
                    }
                    updateMarkers();
                  });
                },
              ),
              Text(Months.values[currentMonth - 1].toString().split(".").last),
              MyIconButton(
                icon: Icon(Icons.chevron_right),
                function: () {
                  setState(() {
                    if (currentMonth == 12) {
                      currentMonth = 1;
                    } else {
                      currentMonth += 1;
                    }
                    updateMarkers();

                  });
                },
              )
            ],
          ),
        ),
        Expanded(
            child: new FlutterMap(
                mapController: mapController,
                options: new MapOptions(
                    interactive: false,
                    center: new LatLng(initializedPosition.latitude,
                        initializedPosition.longitude),
                    ),
                layers: [
                  new TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  new MarkerLayerOptions(markers: markers)
                ]))
      ],
    );
  }


  LatLng findBarycentre(List<Marker> markers){
    double totLat =0;
    double totLong=0;
    for(Marker mark in markers){
      totLat+=mark.point.latitude;
      totLong+=mark.point.longitude;
    }
    totLong/=markers.length;
    totLat/=markers.length;
    return LatLng(totLat,totLong);
  }

  double findLongPath(List<Marker> markers){
    double R=6372.795477598;

    double dist =0;
    for(Marker markA in markers){
      for(Marker markB in markers){
        double distanceInMeters = R * acos (sin (markA.point.latitudeInRad) *sin (markB.point.latitudeInRad) + cos (markA.point.latitudeInRad) *cos (markB.point.latitudeInRad)* cos  (markA.point.longitudeInRad-markB.point.longitudeInRad));
        if(distanceInMeters>dist){
          dist=distanceInMeters;
        }
      }
    }
    return dist;
  }

  List<Marker> createMarkers(Months month) {
    List<Marker> myMarkers = [];
    for (Post post in widget.listPosts[month]) {
      myMarkers.add(new Marker(
          width: 45.0,
          height: 45.0,
          point: new LatLng(post.position.latitude, post.position.longitude),
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
    return myMarkers;
  }

  double findZoom(double dist){
    print(dist);
    if(dist<2){
      return 15;
    }
    if(dist<5){
      return 14;
    }
    if(dist<15){
      return 13;
    }
    if(dist<200){
      return 8;
    }
    else{
      return 1;
    }
    
  }
  
  updateMarkers(){
      markers = createMarkers(Months.values[currentMonth-1]);
    if(markers.length>0) {
      LatLng center =findBarycentre(markers);
      double dist =findLongPath(markers);
      double zoom =findZoom(dist);
      print(zoom);
      mapController.move(center, zoom);

    }
  }
}
