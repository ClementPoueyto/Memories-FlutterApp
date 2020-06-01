import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:memories/controller/map_controller.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/util/map_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:latlong/latlong.dart';

class AddPost extends StatefulWidget {
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  MapController mapController = MapController();
  TextEditingController _title;
  TextEditingController _description;
  Future<Position> _userPosition;
  Position positionToSend;
  String adressToSend;
  File imageTaken;
  List<Marker> markersList = [];
  Future<List<Placemark>> adressPlacemark;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _description = TextEditingController();
    _userPosition = MapHelper().getPosition();

    _userPosition.then((value) => {
          initializedPosition = value,
          positionToSend = value,
            adressPlacemark = Geolocator().placemarkFromCoordinates(value.latitude, value.longitude),
            adressPlacemark.then((adress) => {print(adress[0].locality.toString()), adressToSend=adress.first.locality,} ),
           mapController.onReady.then((controller) => {
                mapController.move(LatLng(value.latitude, value.longitude), 12),
                addMarker(Position(
                    latitude: value.latitude, longitude: value.longitude)),
                updateMarkers(markersList),
              })
        });
  }

  @override
  void dispose() {
    super.dispose();

    _title.dispose();
    _description.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ajouter un post"),
        ),
        body: GestureDetector(
          onTap: () {
            hideKeyBoard();
          },
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Container(
                child: PaddingWith(
                  top: 20,
                  left: 20,
                  right: 20,
                  widget: MyInputTextField(
                    controller: _title,
                    icon: Icons.label,
                    type: TextInputType.text,
                    hint: "Entrez le titre du post",
                    labelText: 'Titre',
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PaddingWith(
                    left: 20,
                    right: 20,
                    widget: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: MyIconButton(
                          icon: Icon(Icons.photo_camera),
                          function: () {
                            takePicture(ImageSource.gallery);
                          },
                        )),
                  ),
                  PaddingWith(
                    left: 20,
                    right: 20,
                    widget: Container(
                      height: 75.0,
                      child: (imageTaken == null)
                          ? Center(child: Text("aucune image"))
                          : Row(children: <Widget>[
                              Image.file(imageTaken),
                              PaddingWith(
                                  left: 15,
                                  right: 15,
                                  widget: MyIconButton(
                                    icon: Icon(Icons.delete),
                                    function: () {
                                      setState(() {
                                        imageTaken = null;
                                      });
                                    },
                                  ))
                            ]),
                    ),
                  )
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    new FlutterMap(
                        mapController: mapController,
                        options: new MapOptions(
                            interactive: false,
                            center: new LatLng(initializedPosition.latitude,
                                initializedPosition.longitude),
                            minZoom: 10.0),
                        layers: [
                          new TileLayerOptions(
                              urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c']),
                          new MarkerLayerOptions(markers: markersList)
                        ]),
                    Positioned(
                      child: PaddingWith(
                          right: 15,
                          widget: Container(
                            decoration: const ShapeDecoration(
                              color: Colors.lightBlue,
                              shape: CircleBorder(),
                            ),
                            child: MyIconButton(
                              function: () {
                                _navigateAndDisplaySelection(context);
                              },
                              icon: Icon(Icons.place),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              PaddingWith(
                  left: 20,
                  right: 20,
                  widget: MyInputTextField(
                    type: TextInputType.multiline,
                    controller: _description,
                    icon: Icons.dehaze,
                    hint: "Racontez votre journée",
                    labelText: 'Description',
                  )),
              PaddingWith(
                  top: 20,
                  bottom: 20,
                  left: 10,
                  right: 10,
                  widget: MyButton(
                    name: 'Publier',
                    function: () {
                      sendToFirebase();
                    },
                  )),
            ],
          )),
        ));
  }

  void hideKeyBoard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future<void> takePicture(ImageSource source) async {
    await Permission.photos.request();
    File image = await ImagePicker.pickImage(
        source: source, maxHeight: maxHeightImagePost, maxWidth: maxWidthImagePost, imageQuality: 40);
    if(image!=null){
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
      compressQuality: 100,
      maxWidth: maxWidthImagePost.toInt(),
          aspectRatioPresets:[
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
      maxHeight:maxHeightImagePost.toInt(),
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.redAccent,
        toolbarTitle: "RPS Cropper",
        statusBarColor: Colors.redAccent.shade100,
        backgroundColor: Colors.white,

      ));
      setState(() {
        imageTaken = cropped;
      });
    }

  }

  // Navigator.pop.
  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Map_Controller(positionToSend!=null?newMarker(positionToSend):newMarker(initializedPosition))),
    ).then((value) => {
          if (value != null){
              setState(() {
                positionToSend = value;
                adressPlacemark = Geolocator().placemarkFromCoordinates(positionToSend.latitude, positionToSend.longitude);
                adressPlacemark.then((adress) => {print(adress[0].locality.toString()), adressToSend=adress.first.administrativeArea,} );
                _userPosition = Future(() {
                  print(positionToSend);
                  return positionToSend;
                });
                mapController.move(
                    LatLng(positionToSend.latitude, positionToSend.longitude),
                    12);
                addMarker(Position(
                    latitude: value.latitude, longitude: value.longitude));
              })
            }
        });
  }

  sendToFirebase() {
    hideKeyBoard();
    if (imageTaken != null &&
        _title.text != null &&
        _title.text != "" &&
        positionToSend != null &&
        adressToSend != null
    ) {
      Navigator.pop(context);

      FireHelper().addpost(
          me.uid, _title.text, _description.text, positionToSend,adressToSend, imageTaken);
    }
  }

  void addMarker(Position position) {
    this.markersList = [
      newMarker(position)
    ];
  }
  
  Marker newMarker(Position position){
    return new Marker(
        width: 45.0,
        height: 45.0,
        point: new LatLng(position.latitude, position.longitude),
        builder: (context) => new Container(
          child: IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.blue,
            iconSize: 45.0,
            onPressed: () {},
          ),
        ));
  }

  updateMarkers(List<Marker> update) {
    if(mounted)
    setState(() {
      this.markersList = update;
    });
  }
}
