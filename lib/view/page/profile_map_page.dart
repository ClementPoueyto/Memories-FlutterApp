import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:memories/models/post.dart';
import 'package:memories/util/map_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:latlong/latlong.dart';


class ProfileMapPage extends StatefulWidget{

  final Map<Months, List<Post>> listPosts;

  ProfileMapPage(this.listPosts);

  _ProfileMapState createState() => _ProfileMapState();
}

class _ProfileMapState extends State<ProfileMapPage>{
  Future<Position> _userPosition;
  int currentMonth=DateTime.now().month;
  List<Marker> markers;
  Stream test;

  @override
  void initState() {
    super.initState();
    _userPosition = MapHelper().getPosition();
    _userPosition.then((value) => initializedPosition=value);
    markers=createMarkers(Months.values[currentMonth-1]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Column(children: <Widget>[

      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.15-kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: <Widget>[
            MyIconButton(icon: Icon(Icons.chevron_left),function: (){setState(() {
               if(currentMonth==1){
                 currentMonth=12;
               }
               else{
                 currentMonth-=1;
               }
               this.markers=createMarkers(Months.values[currentMonth-1]);


            });},),
            Text(Months.values[currentMonth-1].toString().split(".").last),
            MyIconButton(icon: Icon(Icons.chevron_right),function: (){
              setState(() {
                if(currentMonth==12){
                  currentMonth=1;
                }
                else{
                  currentMonth+=1;
                }
                this.markers=createMarkers(Months.values[currentMonth-1]);
              });
            },)
          ],
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height*0.75-kToolbarHeight,
        child : MyMap(_userPosition,initializedPosition,markers))

    ],);
  }

  List<Marker> createMarkers(Months month){
    List<Marker> myMarkers =[];
    for(Post post in widget.listPosts[month]){
      print("ola"+post.position.toString());

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
      return myMarkers;
    }
  }
}