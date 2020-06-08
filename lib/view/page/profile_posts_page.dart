import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memories/delegate/header_post_delegate.dart';
import 'package:memories/models/post.dart';
import 'package:memories/util/date_helper.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/page/profile_map_page.dart';
import 'package:memories/view/tiles/profile_post_tile.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePostsPage extends StatefulWidget {
  final bool isme;
  final User user;
  final List<DocumentSnapshot> documents;
  final Map<String, List<Post>> listPosts;
  ProfilePostsPage(this.isme, this.user, this.documents, this.listPosts);

  _ProfilePostsState createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePostsPage> {
  ScrollController controller;
  double _expanded = 200.0;
  File imageTaken;

  bool get _showTitle {
    return controller.hasClients &&
        controller.offset > _expanded - kToolbarHeight;
  }

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    if (controller != null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(controller: controller, slivers: list());
  }

  List<Widget> list() {
    List<Widget> list = List();
    list.add(
      SliverAppBar(
        leading: SizedBox.shrink(),
        expandedHeight: _expanded,
        backgroundColor: base,
        elevation: 10,
        floating: true,
        pinned: false,
        actions: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Row(
              children: <Widget>[
                if (widget.isme)
                  PaddingWith(
                    top: 0,
                    left: 10,
                    right: 10,
                    bottom: 0,
                    widget :MyIconButton(
                    icon: editIcon,
                    color: white,
                    function: () {
                      changeUser();
                    },
                  ),
                  ),
                PaddingWith(
                  top: 0,
                  left: 10,
                  right: 10,
                  bottom: 0,
                  widget :MyIconButton(
                  icon: Icon(Icons.airplanemode_active),
                  color: white,
                  function: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileMapPage(widget.listPosts,widget.user)));
                  },
                ),
                ),
              ],
            ),
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          title: MyText(
            widget.user.firstName + " " + widget.user.lastName,
            color: white,
            fontSize: 20,
          ),
          background: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider((widget.user.imageUrl !=
                              null &&
                          widget.user.imageUrl != "")
                      ? widget.user.imageUrl
                      : "https://green-growth-org-uk.cdn.gofasterstripes.download/sites/default/files/default_images/anonymous-profile_0.png"),
                  fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
    widget.listPosts.keys.forEach(
      (element) {
        if (widget.listPosts.length > 0) {
          list.add(
            SliverPersistentHeader(
              pinned: false,
              delegate: MyHeaderPost(
                  month: DateHelper().getValue(Months.values[
                      int.parse(element.toString().split('/').first) - 1]),
                  year: element.toString().split("/").last,
                  callback: () {},
                  scrolled: _showTitle),
            ),
          );
          list.add(
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              delegate: SliverChildListDelegate(
                [
                  for (Post post in widget.listPosts[element])
                    ProfilePostTile(post: post, user: widget.user)
                ],
              ),
            ),
          );
        }
      },
    );
    return list;
  }

  void changeUser() {
    if (widget.user.uid == me.uid) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext ctx) {
            return Container(
              decoration: BoxDecoration(
                color: white,

              ),
              height: MediaQuery.of(context).size.height/4,
              child: Card(
                elevation: 5.0,
                margin: EdgeInsets.all(7.5),
                child: Container(
                  color: base,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MyText("Modifier la photo de profil"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Card(
                            color: white,
                            child: IconButton(
                                icon: cameraIcon,
                                onPressed: (() {
                                  takePicture(ImageSource.camera);
                                  Navigator.pop(ctx);
                                })),
                          ),
                          Card(
                            color: white,
                            child: IconButton(
                                icon: galleryIcon,
                                onPressed: () {
                                  takePicture(ImageSource.gallery);
                                  Navigator.pop(ctx);
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
  }

  Future<void> takePicture(ImageSource source) async {
    await Permission.photos.request();
    File image = await ImagePicker.pickImage(
        source: source,
        maxHeight: maxHeightImagePost,
        maxWidth: maxWidthImagePost,
        imageQuality: 60);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          compressQuality: 100,
          maxWidth: maxWidthImagePost.toInt(),
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
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
        if (cropped != null) {
          imageTaken = cropped;
          FireHelper().modifyPicture(imageTaken);
        }
      });
    }
  }
}
