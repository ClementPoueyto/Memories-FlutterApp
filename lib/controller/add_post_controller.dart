import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:memories/controller/map_selector_controller.dart';
import 'package:memories/models/post.dart';
import 'package:memories/util/alert_helper.dart';
import 'package:memories/util/api_post_helper.dart';
import 'package:memories/util/date_helper.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/util/map_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

/// Controller Ajout d'une publication (post)
class AddPost extends StatefulWidget {
  final Post post;
  final ValueNotifier<List<Post>> notifierPosts;

  AddPost(this.post,this.notifierPosts);
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  MapController mapController = MapController();
  TextEditingController _title;
  TextEditingController _description;
  TextEditingController _adress;
  Future<Position> _userPosition;
  Position positionToSend;
  File imageTaken;
  String imageUrl;
  List<Marker> markersList = [];
  Future<List<Placemark>> adressPlacemark;
  bool private = false;
  bool fileDeleted = false;
  Post post;
  final _formKey = GlobalKey<FormState>();
  Future<Position> lastKnownposition;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _description = TextEditingController();
    _adress = TextEditingController();
    _userPosition = Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    if (widget.post != null) {
      post = widget.post;
      imageUrl = post.imageUrl;
      _title.text = post.title;
      _description.text = post.description;
      _adress.text = post.adress;
      private = post.isPrivate;
      _adress.text = post.adress;
      _userPosition = Future.value(post.position);
      positionToSend = post.position;
    } else {
      _userPosition = MapHelper().getPosition();
    }
    _userPosition.then((value) => {
          if (value != null)
            {
              initializedPosition = value,
              positionToSend = value,
              adressPlacemark = Geolocator()
                  .placemarkFromCoordinates(value.latitude, value.longitude),
              adressPlacemark.then((adress) => {
                    if (mounted) _adress.text = getStringAdress(adress),
                  }),
              mapController.onReady
                  .then((controller) => {moveCameraTo(positionToSend)})
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
          if (post != null)
            MyIconButton(
              icon: closeIcon,
              function: () {
                AlertHelper().delete(
                    context,
                    widget.notifierPosts,
                    post.id,
                    post.imageUrl != null && post.imageUrl != ""
                        ? DateHelper().myDate(post.date)
                        : "",
                    "Voulez-vous vraiment supprimer cette publication ?",
                    "Les données associées seront perdues");
              },
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
                                    imageUrl != null &&
                                    imageUrl != "")
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
                                              fileDeleted=true;
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
                                                  fileDeleted = true;
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
                              initialPosition: LatLng(
                                  initializedPosition.latitude,
                                  initializedPosition.longitude),
                              zoom: 10,
                              minZoom: 3,
                              maxZoom: 18,
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
                        name: post != null ? "Modifier" : 'Publier',
                        function: ()async {
                          if (_formKey.currentState.validate()) {
                            Post sentPost =await sendToDatabase();
                            notifyMainController(sentPost);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
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

  ///Range le clavier
  void hideKeyBoard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  ///déplace la camera de carte à une position donnée
  moveCameraTo(Position position) {
    mapController.move(LatLng(position.latitude, position.longitude), 12);
    addMarker(
        Position(latitude: position.latitude, longitude: position.longitude));
    updateMarkers(markersList);
  }

  ///Verifie le titre de la publication
  String validatorPost(value) {
    if (value.isEmpty) {
      return 'Merci de remplir ce champ';
    }
    if (value.length > 50) {
      return "50 caractères maximum";
    }
    return null;
  }

  ///Verifie la description de la publication
  String validatorDesc(value) {
    if (value.length > 500) {
      return "500 caractères maximum";
    }
    return null;
  }

  ///Verifie l'adresse de la publication
  String validatorAdress(value) {
    if (value.length > 100) {
      return "100 caractères maximum";
    }
    return null;
  }

  /// Gere l'ajout de photo via une source (caméra ou gallerie)
  /// puis redirige vers le crop d'image
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
  ///Prend en compte la nouvelle position selectionnée par l'utilisateur et modifie l'adresse
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
                adressPlacemark = Geolocator()
                    .placemarkFromCoordinates(
                        positionToSend.latitude, positionToSend.longitude)
                    .catchError((e) {
                  print(e);
                });
                adressPlacemark
                    .then((adress) => {
                          _adress.text = getStringAdress(adress),
                        })
                    .catchError((e) {
                  print(e);
                });
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

  ///Verifie si l'utilisateur a deja publié aujourd'hui
  bool checkAlreadyPublished(DateTime datePost) {
    for (post in myListPosts) {
      if (DateHelper().isTheSameDay(post.date, datePost)) {
        return true;
      }
    }
    return false;
  }

  ///Envoie les donnée à la base de donnée
  Future<Post> sendToDatabase() async {
    Future<Post> send;
    hideKeyBoard();
    //si le post n'est pas vide
    if (_title.text != null && _title.text != "") {
      Map<String, dynamic> futurePost = await addpost(
          context,
          me.uid,
          _title.text,
          _description.text,
          positionToSend,
          _adress.text,
          imageTaken,
          private,
          post != null
              ? post.date.millisecondsSinceEpoch
              : DateTime.now().millisecondsSinceEpoch,
        fileDeleted
      );


      if (post == null) { //si création de post
        if (checkAlreadyPublished(  // verifie si deja publié
            DateTime.fromMillisecondsSinceEpoch(futurePost[keyDate]))) {
           AlertHelper().overwrite(
              context, "erreur", "Vous avez deja posté", Map(), "ok");
        }
        send= ApiPostHelper().postMyPost(context, futurePost);
      }
      else {
        send = ApiPostHelper()
            .updateMyPost(context, futurePost, post.id);
        send
            .whenComplete(() => Fluttertoast.showToast(
                msg: "Modifié avec succès",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                fontSize: 16.0))
            .catchError((err) => Fluttertoast.showToast(
                msg: "erreur : " + err.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                fontSize: 16.0));
      }
      return send;
    }
  }

  void addMarker(Position position) {
    this.markersList = [newMarker(position)];
  }

  ///Ajoute un marker sur la carte en fonction de la position
  Marker newMarker(Position position) {
    return Marker(
      width: 85.0,
      height: 85.0,
      point: new LatLng(position.latitude, position.longitude),
      builder: (context) => Container(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.location_on),
              color: Colors.blue,
              iconSize: 40.0,
              onPressed: () {},
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  ///Met à jour la liste des markers
  updateMarkers(List<Marker> update) {
    if (mounted)
      setState(() {
        this.markersList = update;
      });
  }

  ///Transforme l'objet Adresse (placemark) en adresse String lisible
  //TODO
  getStringAdress(List<Placemark> adress) {
    String res = "";
    if (adress.first.locality != null && adress.first.locality != "") {
      res += adress.first.locality;
      if ((adress.first.country != null && adress.first.country != "")) {
        res += ", ";
      }
    }
    if (adress.first.country != null && adress.first.country != "") {
      res += adress.first.country;
    }
    return res;
  }

  ///Crée un post via json
  Future<Map<String, dynamic>> addpost(
      BuildContext context,
      String uid,
      String title,
      String description,
      Position position,
      String adress,
      File file,
      bool private,
      int date,
      bool fileDeleted) async {
    List<dynamic> likes = [];
    List<dynamic> comments = [];
    Map<String, dynamic> map = {
      keyUid: uid,
      keyTitle: title,
      keyLikes: likes,
      keyComments: comments,
      keyDate: date,
      keyIsPrivate: private,
    };
    if (description != null && description != "") {
      map[keyDescription] = description;
    }
    if (position != null && position != "") {
      map[keyPosition] = {
        "latitude": position.latitude,
        "longitude": position.longitude
      };
    }
    if (adress != null && adress != "") {
      map[keyAdress] = adress;
    }
    if (file != null) {
      StorageReference ref = FireHelper().storage_posts.child(uid).child(
          DateHelper().myDate(DateTime.fromMillisecondsSinceEpoch(date)));
      final finalised = await FireHelper().addImage(file, ref);
      map[keyImageURL] = finalised;
      return map;
    } else if (file == null && (imageUrl == null || imageUrl == "")) {
      if (fileDeleted ==true) {
        FireHelper()
            .storage_posts
            .child(me.uid)
            .child(DateHelper().myDate(post.date))
            .delete();
      }
      map[keyImageURL] = "";
      return Future.value(map);
    } else {
      return Future.value(map);
    }
  }
  notifyMainController(Post newPost){
    List<Post> posts =widget.notifierPosts.value;

    if(post!=null) {
      posts.removeWhere((element) => element.id==newPost.id);
    }
    posts.add(newPost);
    widget.notifierPosts.value=posts;
    widget.notifierPosts.notifyListeners();

  }
}
