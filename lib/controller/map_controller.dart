import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:memories/view/my_material.dart';

class Map_Controller extends StatefulWidget {
  Marker initMarker;
  Map_Controller(this.initMarker);
  _MapState createState() => _MapState();
}

class _MapState extends State<Map_Controller> {

  Marker spotted;
  TextEditingController search;

  MapController _mapController= MapController();
  @override
  void initState() {
    super.initState();
    search=TextEditingController();
    spotted=widget.initMarker;
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Expanded(child :Stack(
                children: <Widget>[
                  new FlutterMap(
                      mapController: _mapController,
                      options: new MapOptions(
                          onTap: getTapLatLng,
                          interactive: true,
                          center: new LatLng(widget.initMarker.point.latitude,
                              widget.initMarker.point.longitude),
                          zoom: 10),
                      layers: [
                        new TileLayerOptions(
                            urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c']),
                        new MarkerLayerOptions(
                            markers: spotted!=null?[spotted]:[])

                      ]),

                  Positioned(
                    child: PaddingWith(
                      left: 20,
                      right: 20,
                      top: 30,
                      widget :MySearchBar(
                        controller: search ,
                        labelText: 'Rechercher',
                        hint: "Entrez une adresse",
                        icon:Icons.search,
                        obscure: false,
                        onsubmitted: searchForPlace,
                      )
                    ),),
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  PaddingWith(
                    top: 20,
                    widget: MyButton(
                      function: () { Navigator.pop(context);},
                      name: "Annuler",
                    ),
                  ),
                  PaddingWith(
                    top: 20,
                    widget: MyButton(
                      function: () {
                        Navigator.pop(context,Position(latitude: spotted.point.latitude,longitude: spotted.point.longitude));},
                      name: "Valider",
                    ),
                  )
                ],
              ),

            ],
          )) ,
    );
  }

  getTapLatLng(LatLng point){
    hideKeyBoard();
    setState(() {
      spotted=  Marker(
          width: 45.0,
          height: 45.0,
          point: new LatLng(point.latitude, point.longitude),
          builder: (context) => new Container(
            child: IconButton(
              icon: Icon(Icons.location_on),
              color: Colors.blue,
              iconSize: 45.0,
              onPressed: () {
              },
            ),
          ));
    });
  }

  searchForPlace(String input) async{
    List<Placemark> placemark = await Geolocator().placemarkFromAddress(input);
    if(placemark.length>0){
      LatLng searchLatLng = LatLng(placemark[0].position.latitude,placemark[0].position.longitude);
      getTapLatLng(searchLatLng);
      _mapController.move(searchLatLng, 10);
    }

  }

  void hideKeyBoard(){
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
