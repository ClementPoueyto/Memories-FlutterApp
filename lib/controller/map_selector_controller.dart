import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
import 'package:memories/view/my_material.dart';

class Map_Controller extends StatefulWidget {
  Marker initMarker;
  Map_Controller(this.initMarker);
  _MapState createState() => _MapState();
}

class _MapState extends State<Map_Controller> {
  Marker spotted;
  TextEditingController search;

  MapController _mapController = MapController();
  @override
  void initState() {
    super.initState();
    search = TextEditingController();
    spotted = widget.initMarker;
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[

          Scaffold(
            resizeToAvoidBottomPadding : false,
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Stack(
                      children: <Widget>[
                        new FlutterMap(
                            mapController: _mapController,
                            options: new MapOptions(
                                plugins: [

                                ],
                                onTap: getTapLatLng,
                                interactive: true,
                                center: new LatLng(
                                    widget.initMarker.point.latitude,
                                    widget.initMarker.point.longitude),
                                zoom: 10),
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
                              new MarkerLayerOptions(
                                  markers: spotted != null ? [spotted] : [])
                            ]),
                        Positioned(
                          child: PaddingWith(
                              left: 20,
                              right: 20,
                              top: 40,
                              widget: GestureDetector(
                                onTap: hideKeyBoard,
                                child :MapBoxPlaceSearchWidget(
                                popOnSelect: false,
                                apiKey:
                                "pk.eyJ1IjoibWVuY2VsdCIsImEiOiJjazl5ZXVnOXUwb3NtM2lvOHl4b3VtMGNmIn0.kyXnFYWW15ocu0mg9ytqCg",
                                limit: 5,
                                language: "fr",
                                height: MediaQuery.of(context).size.height / 2,
                                searchHint: 'Rechercher une adresse',
                                onSelected: (place) {
                                  searchForPlace(place);
                                },
                                context: context,
                              ),),
                        ),
                        ),
                      ],
                    )),
                  ],
                )),
          ),
          Positioned(
            bottom: 10,
            left: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                PaddingWith(
                  top: 20,
                  widget: MyButton(
                    color: white,
                    function: () {
                      Navigator.pop(context);
                    },
                    name: "Annuler",
                  ),
                ),
                PaddingWith(
                  top: 20,
                  left: 15,
                  widget: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: MyButton(
                      color: base,
                      borderColor: accent,
                      textColor: white,
                      function: () {
                        Navigator.pop(
                            context,
                            Position(
                                latitude: spotted.point.latitude,
                                longitude:
                                spotted.point.longitude));
                      },
                      name: "Valider",
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  getTapLatLng(LatLng point) {
    if(mounted&&!_keyboardIsVisible()) {
      setState(() {
        spotted = Marker(
          width: 85.0,
          height: 85.0,
          point: new LatLng(point.latitude, point.longitude),
          builder: (context) =>
              Container(
                child: Column(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.location_on),
                      color: Colors.blue,
                      iconSize: 40.0,
                      onPressed: () {},
                    ),
                    SizedBox(height: 25,),

                  ],
                ),
              ),
        );
      });
    }
    else{
      hideKeyBoard();
    }
  }

  searchForPlace(MapBoxPlace input) async {
    LatLng point = LatLng(input.center[1], input.center[0]);
    getTapLatLng(point);
    _mapController.move(point, 10);
  }

  void hideKeyBoard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }
}
