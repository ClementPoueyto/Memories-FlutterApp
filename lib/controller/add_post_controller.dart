import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:memories/controller/map_selector_controller.dart';
import 'package:memories/models/post.dart';
import 'package:memories/util/alert_helper.dart';
import 'package:memories/util/date_helper.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/util/map_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:latlong/latlong.dart';

class AddPost extends StatefulWidget {
  Post post;
  AddPost(this.post);
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  MapController mapController = MapController();
  TextEditingController _title;
  TextEditingController _description;
  TextEditingController _adress;
  Future<Position> _userPosition;
  Position positionToSend;
  String adressToSend;
  File imageTaken;
  String imageUrl;
  List<Marker> markersList = [];
  Future<List<Placemark>> adressPlacemark;
  bool private = false;
  Post post;
  final _formKey = GlobalKey<FormState>();
  Future<Position> lastKnownposition;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _description = TextEditingController();
    _adress = TextEditingController();
    _userPosition =  Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    if (widget.post != null) {
      post = widget.post;
      imageUrl = post.imageUrl;
      _title.text = post.title;
      _description.text = post.description;
      _adress.text = post.adress;
      private = post.isPrivate;
      adressToSend = post.adress;
      _userPosition = Future.value(post.position);
      positionToSend = post.position;

    } else {
      _userPosition = MapHelper().getPosition();
    }
    _userPosition.then((value) => {
      if(value!=null){
        initializedPosition = value,
        positionToSend = value,
        adressPlacemark = Geolocator()
            .placemarkFromCoordinates(value.latitude, value.longitude),
        adressPlacemark.then((adress) =>
        {
          adressToSend = getStringAdress(adress),
          _adress.text = adressToSend,
        }),
        mapController.onReady.then((controller) => {moveCameraTo(positionToSend)})
      }
        });
  }

  @override
  void dispose() {
    super.dispose();

    _title.dispose();
    _adress.dispose();
    _description.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un post"),
        actions: <Widget>[
          if(post!=null)
            MyIconButton(
            icon: closeIcon,
            function: (){AlertHelper().delete(
                context,
                post.documentId,DateHelper().myDate(post.date) ,"Voulez-vous vraiment supprimer cette publication ?", "Les données associées seront perdues");},
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          hideKeyBoard();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Card(
              elevation: 2,
              child: Column(
                children: <Widget>[
                  Container(
                    child: PaddingWith(
                      top: 20,
                      left: 20,
                      right: 20,
                      widget: MyInputTextField(
                        validator: validatorPost,
                        colorText: black,
                        controller: _title,
                        icon: Icons.short_text,
                        type: TextInputType.text,
                        hint: "Entrez le titre du post",
                        labelText: 'Titre',
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        PaddingWith(
                          left: 10,
                          right: 20,
                          widget: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: MyIconButton(
                                icon: Icon(Icons.photo_camera),
                                function: () {
                                  takePicture(ImageSource.camera);
                                },
                              )),
                        ),
                        PaddingWith(
                          left: 10,
                          right: 10,
                          widget: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: MyIconButton(
                                icon: Icon(Icons.photo),
                                function: () {
                                  takePicture(ImageSource.gallery);
                                },
                              )),
                        ),
                        PaddingWith(
                          left: 15,
                          right: 15,
                          widget: Container(
                            height: 75.0,
                            child: (post != null &&
                                    imageTaken == null &&
                                    imageUrl != null&&imageUrl!="")
                                ? Row(children: <Widget>[
                                    Image(
                                        image: CachedNetworkImageProvider(
                                            imageUrl)),
                                    PaddingWith(
                                        left: 15,
                                        right: 0,
                                        widget: MyIconButton(
                                          icon: Icon(Icons.delete),
                                          function: () {
                                            setState(() {
                                              imageUrl = null;
                                            });
                                          },
                                        ))
                                  ])
                                : (imageTaken == null)
                                    ? Center(child: Text("aucune image"))
                                    : Row(children: <Widget>[
                                        Image.file(imageTaken),
                                        PaddingWith(
                                            left: 15,
                                            right: 0,
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
                  ),
                  PaddingWith(
                    left: 10,
                    right: 10,
                    widget: Card(
                      elevation: 5,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        child: Stack(
                          alignment: AlignmentDirectional.centerEnd,
                          children: <Widget>[
                            MyMap(
                              mapController: mapController,
                              isInteractive: false,
                              initialPosition: LatLng(initializedPosition.latitude,initializedPosition.longitude),
                              zoom: 10,
                              markers: markersList,
                            ),

                            Positioned(
                              child: PaddingWith(
                                  right: 15,
                                  widget: Container(
                                    decoration: const ShapeDecoration(
                                      color: Colors.lightGreen,
                                      shape: CircleBorder(),
                                    ),
                                    child: MyIconButton(
                                      function: () {
                                        _navigateAndDisplaySelection(context);
                                      },
                                      icon: Icon(Icons.my_location),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  PaddingWith(
                      left: 20,
                      right: 20,
                      widget: MyInputTextField(
                        validator: validatorAdress,
                        type: TextInputType.text,
                        controller: _adress,
                        icon: Icons.place,
                        hint: "Adresse de l'évènement",
                        labelText: 'Lieu',
                      )),
                  PaddingWith(
                      left: 20,
                      right: 20,
                      widget: MyInputTextField(
                        validator: validatorDesc,
                        type: TextInputType.multiline,
                        controller: _description,
                        icon: Icons.dehaze,
                        hint: "Racontez votre journée",
                        labelText: 'Description',
                      )),
                  PaddingWith(
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        MyText(
                          "Public",
                          color: black,
                        ),
                        Radio(
                          value: false,
                          groupValue: private,
                          onChanged: (val) {
                            setState(() {
                              private = val;
                            });
                          },
                        ),
                        Container(
                          width: 30,
                        ),
                        MyText(
                          "Privé",
                          color: black,
                        ),
                        Radio(
                          value: true,
                          groupValue: private,
                          onChanged: (val) {
                            setState(() {
                              private = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  PaddingWith(
                    top: 20,
                    bottom: 20,
                    left: 10,
                    right: 10,
                    widget: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: MyButton(
                        textColor: white,
                        color: base,
                        borderColor: accent,
                        name: post!=null?"Modifier":'Publier',
                        function: () {
                          if (_formKey.currentState.validate()) {
                            sendToFirebase();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void hideKeyBoard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  moveCameraTo(Position position) {
    mapController.move(LatLng(position.latitude, position.longitude), 12);
    addMarker(
        Position(latitude: position.latitude, longitude: position.longitude));
    updateMarkers(markersList);
  }

  String validatorPost(value) {
    if (value.isEmpty) {
      return 'Merci de remplir ce champ';
    }
    if (value.length > 50) {
      return "50 caractères maximum";
    }
    return null;
  }

  String validatorDesc(value) {
    if (value.length > 500) {
      return "500 caractères maximum";
    }
    return null;
  }

  String validatorAdress(value){
    if(value.length>100){
      return "100 caractères maximum";
    }
  }

  Future<void> takePicture(ImageSource source) async {
    File image = await ImagePicker.pickImage(
        source: source,
        maxHeight: maxHeightImagePost,
        maxWidth: maxWidthImagePost,
        imageQuality: 40);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          compressQuality: 100,
          maxWidth: maxWidthImagePost.toInt(),
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          maxHeight: maxHeightImagePost.toInt(),
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: base,
            toolbarTitle: "Memories",
            statusBarColor: accent,
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
      MaterialPageRoute(
          builder: (context) => Map_Controller(positionToSend != null
              ? newMarker(positionToSend)
              : newMarker(initializedPosition))),
    ).then((value) => {
          if (value != null)
            {
              setState(() {
                positionToSend = value;
                adressPlacemark = Geolocator().placemarkFromCoordinates(
                    positionToSend.latitude, positionToSend.longitude).catchError((e){print(e);});
                adressPlacemark.then((adress) => {
                      adressToSend = getStringAdress(adress),
                  
                  _adress.text=adressToSend,
                    }).catchError((e){print(e);});
                _userPosition = Future(() {
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
    if (_title.text != null && _title.text != "") {
      if (post == null) {
        FireHelper().addpost(me.uid, _title.text, _description.text,
            positionToSend, adressToSend, imageTaken, private);
      } else {
        FireHelper().modifyPost(
          post.documentId,
            me.uid,
            _title.text,
            _description.text,
            positionToSend,
            adressToSend,
            imageTaken,
            imageUrl,
            private,
            post.date,
            post.likes,
            post.comments);
      }
      Navigator.of(context).popUntil((route) => route.isFirst);

    }

  }

  void addMarker(Position position) {
    this.markersList = [newMarker(position)];
  }

  Marker newMarker(Position position) {
    return
      Marker(
        width: 85.0,
        height: 85.0,
        point: new LatLng(position.latitude, position.longitude),
        builder: (context) => Container(
          child :Column(
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

  }

  updateMarkers(List<Marker> update) {
    if (mounted)
      setState(() {
        this.markersList = update;
      });
  }
  
  getStringAdress(List<Placemark> adress){
    String res="";
    if(adress.first.locality!=null&&adress.first.locality!=""){
      res+=adress.first.locality;
      if((adress.first.country!=null&&adress.first.country!="")){
        res+=", ";
      }
    }
    if(adress.first.country!=null&&adress.first.country!=""){
      res+=adress.first.country;
    }
    return res;
  }
}
