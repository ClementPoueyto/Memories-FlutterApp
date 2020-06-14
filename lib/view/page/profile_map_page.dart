import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:memories/controller/detail_post_controller.dart';
import 'package:memories/models/post.dart';
import 'package:memories/util/date_helper.dart';
import 'package:memories/util/map_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class ProfileMapPage extends StatefulWidget {
  final Map<String, List<Post>> listPosts;
  final User user;

  ProfileMapPage(this.listPosts, this.user);

  _ProfileMapState createState() => _ProfileMapState();
}

class _ProfileMapState extends State<ProfileMapPage> {
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  List<Marker> markers = [];
  MapController mapController;
  List<String> keyMonths;
  int index;
  Map<String, List<Post>> listPostsToDisplay;

  @override
  void initState() {
    super.initState();
    listPostsToDisplay = initPosts();
    keyMonths = listPostsToDisplay.keys.toList();
    index = keyMonths
        .indexOf(currentMonth.toString() + "/" + currentYear.toString());
    if (index == null) {
      index = 0;
    }

    mapController = new MapController();
    if (listPostsToDisplay.length > 0) {
      mapController.onReady.then((value) => {
            setState(() {
              updateMarkers();
            })
          });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: PaddingWith(
          widget: FloatingActionButton(
        child: closeIcon,
        onPressed: () {
          Navigator.pop(context);
        },
      )),
      body: Stack(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height,
              child:
              new FlutterMap(
                  mapController: mapController,
                  options: new MapOptions(
                    minZoom: 3,
                    maxZoom: 18,
                    interactive: true,
                    center: new LatLng(initializedPosition.latitude,
                        initializedPosition.longitude),
                  ),
                  layers: [
                    new TileLayerOptions(
                      urlTemplate:
                          "https://api.mapbox.com/styles/v1/mencelt/ckammy4co4y781inrztqiiwvp/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWVuY2VsdCIsImEiOiJjazl5ZXVnOXUwb3NtM2lvOHl4b3VtMGNmIn0.kyXnFYWW15ocu0mg9ytqCg",
                      additionalOptions: {
                        'accessToken':
                            'pk.eyJ1IjoibWVuY2VsdCIsImEiOiJjazl5ZXVnOXUwb3NtM2lvOHl4b3VtMGNmIn0.kyXnFYWW15ocu0mg9ytqCg',
                        'id': 'mapbox.streets',
                      },
                    ),
                    new MarkerLayerOptions(markers: markers)
                  ])),
          if (listPostsToDisplay.length > 0)
            PaddingWith(
              top: 40,
              left: 15,
              right: 15,
              widget: Container(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      MyIconButton(
                        icon: Icon(Icons.chevron_left),
                        function: () {
                          setState(() {
                            if (index < keyMonths.length - 1) {
                              index += 1;
                              updateMarkers();
                            }
                          });
                        },
                      ),
                      Text(DateHelper().getValue(Months.values[
                              int.parse(keyMonths[index].split("/").first) -
                                  1]) +
                          " " +
                          keyMonths[index].split("/").last),
                      MyIconButton(
                        icon: Icon(Icons.chevron_right),
                        function: () {
                          setState(() {
                            if (index > 0) {
                              index -= 1;
                              updateMarkers();
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  LatLng findBarycentre(List<Marker> markers) {
    double totLat = 0;
    double totLong = 0;
    for (Marker mark in markers) {
      totLat += mark.point.latitude;
      totLong += mark.point.longitude;
    }
    totLong /= markers.length;
    totLat /= markers.length;
    return LatLng(totLat, totLong);
  }

  Map<String, List<Post>> initPosts() {
    Map<String, List<Post>> myList = Map();
    widget.listPosts.forEach((key, value) {
      value.forEach((element) {
        if (element.position != null) {
          if (myList[key] == null) {
            myList[key] = [];
          }
          myList[key].add(element);
        }
      });
    });
    return myList;
  }

  double findLongPath(List<Marker> markers) {
    double R = 6372.795477598;

    double dist = 0;
    for (Marker markA in markers) {
      for (Marker markB in markers) {
        double distanceInMeters = R *
            acos(sin(markA.point.latitudeInRad) *
                    sin(markB.point.latitudeInRad) +
                cos(markA.point.latitudeInRad) *
                    cos(markB.point.latitudeInRad) *
                    cos(markA.point.longitudeInRad -
                        markB.point.longitudeInRad));
        if (distanceInMeters > dist) {
          dist = distanceInMeters;
        }
      }
    }
    return dist;
  }

  List<Marker> createMarkers(String key) {
    List<Marker> myMarkers = [];
    if (listPostsToDisplay[key] != null) {
      for (Post post in listPostsToDisplay[key]) {
        myMarkers.add(Marker(
          width: 120.0,
          height: 120.0,
          point: new LatLng(post.position.latitude, post.position.longitude),
          builder: (context) => Container(
            child :Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(3.0),

                  child: (post.imageUrl!=null&&post.imageUrl!="")?Image(
                      fit: BoxFit.fitWidth,
                      width: 35,
                      image: CachedNetworkImageProvider(post.imageUrl)
                  ):Container(
                    width: 35,
                    height:35,
                    color: white,
                    child: Center(child :MyText(post.title,color: black,fontSize: 6,),),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.location_on),
                  color: Colors.blue,
                  iconSize: 40.0,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPost(post,widget.user)));
                  },
                ),
                SizedBox(height: 25,),

              ],
            ),
          ),
        ),);
      }
    }
    return myMarkers;
  }

  double findZoom(double dist) {
    if (dist < 2) {
      return 13;
    }
    if (dist < 5) {
      return 11;
    }
    if (dist < 15) {
      return 10;
    }
    if (dist < 100) {
      return 9;
    }
    if (dist < 200) {
      return 8;
    }
    if (dist < 500) {
      return 7;
    }
    if (dist < 1000) {
      return 6;
    } else {
      return 3;
    }
  }

  updateMarkers() {
    markers = createMarkers(keyMonths[index]);
    if (markers.length > 0) {
      LatLng center = findBarycentre(markers);
      double dist = findLongPath(markers);
      double zoom = findZoom(dist);
      mapController.move(center, zoom);
    }
  }
}
