import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  Future<Position> _userPosition;
  File imageTaken;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _description = TextEditingController();
    _userPosition = MapHelper().getPosition();
    _userPosition.then((value) =>{
    initializedPosition=value,
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
                    MyMap(_userPosition,initializedPosition,[]),
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
    await Permission.photos.request();
    File image = await ImagePicker.pickImage(
        source: source, maxHeight: 500.0, maxWidth: 500.0, imageQuality: 10);
    setState(() {
      imageTaken = image;
    });
  }



  sendToFirebase(){
    hideKeyBoard();
    if(imageTaken != null && _title.text!=null &&_title.text!=""){
      Navigator.pop(context);
      _userPosition.then((value) =>
          FireHelper().addpost(me.uid, _title.text, _description.text, value, imageTaken)
      );
    }
  }
}
