import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/util/map_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPost extends StatefulWidget {
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController _title;
  TextEditingController _description;
  Position _userPosition;
  File imageTaken;
  MapboxMapController mapController;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _description = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    if (mapController != null) {
      mapController.removeListener(_onMapChanged);
    }
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
                  left: 10,
                  right: 10,
                  widget: MyTextField(
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
                            print("test");
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
                    _buildMapBox(context),
                    Positioned(

                        child: PaddingWith(right : 15,widget : Container(
                      decoration: const ShapeDecoration(
                        color: Colors.lightBlue,

                        shape: CircleBorder(),
                      ),
                      child: MyIconButton(
                        function: () { },
                        icon: Icon(Icons.place),
                      ),
                    )),)
                  ],
                ),
              ),
              PaddingWith(
                  left: 10,
                  right: 10,
                  widget: MyTextField(
                    type: TextInputType.multiline,
                    controller: _description,
                    icon: Icons.dehaze,
                    hint: "Racontez votre journée",
                    labelText: 'Description',
                  )),
              PaddingWith(
                top:20,
                  bottom: 20,
                  left: 10,
                  right: 10,
                  widget: MyButton(
                    name: 'Publier',
                    function: (){sendToFirebase();},
                  )),
            ],
          )),
        ));
  }

  void hideKeyBoard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future<void> takePicture(ImageSource source) async {
    var status = await Permission.photos.request();
    File image = await ImagePicker.pickImage(
        source: source, maxHeight: 500.0, maxWidth: 500.0);
    setState(() {
      imageTaken = image;
    });
  }

  MapboxMap _buildMapBox(BuildContext context) {
    return MapboxMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(30, 30),
        zoom: 12,
      ),
      trackCameraPosition: true,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: false,
      compassEnabled: false,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      tiltGesturesEnabled: false,
      zoomGesturesEnabled: false,
      myLocationEnabled: true,
    );
  }

  void onMapCreated(MapboxMapController controller) async {
    _userPosition = await MapHelper().getPosition();
    mapController = controller;
    mapController.addListener(_onMapChanged);
    setState(() {});
  }

  void _onMapChanged() {
    setState(() {});
  }
  sendToFirebase(){
    hideKeyBoard();
    if(imageTaken != null && _title.text!=null &&_title.text!=""){
      Navigator.pop(context);
      FireHelper().addpost(me.uid, _title.text, _description.text, _userPosition, imageTaken);
    }
  }
}
