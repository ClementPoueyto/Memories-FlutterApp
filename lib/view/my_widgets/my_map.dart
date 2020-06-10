import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class MyMap extends FlutterMap{
  MyMap({
    @required MapController mapController,
    @required LatLng initialPosition,
    layers,
    List<Marker> markers,
    bool isInteractive : false,
    double minZoom ,
    double maxZoom ,
    double zoom ,
    Function onTap,
  }) : super(
    mapController : mapController,
    options : new MapOptions(
      onTap: onTap,
      interactive: isInteractive,
      minZoom: minZoom,
      maxZoom:maxZoom ,
      zoom: zoom,
      center: new LatLng(initialPosition.latitude,
          initialPosition.longitude),
    ),
    layers :  [
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
    ] ,

  );
}