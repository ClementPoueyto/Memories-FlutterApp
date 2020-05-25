import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:memories/view/my_material.dart';

class ProfileImage extends InkWell {
  ProfileImage({double size :20.0, @required String urlString, @required VoidCallback onPressed}):super(
    onTap : onPressed,
    child : CircleAvatar(
      radius: size,
      backgroundImage: (urlString!=null&&urlString!="")?CachedNetworkImageProvider(urlString):CachedNetworkImageProvider("https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1901&q=80"),
      backgroundColor: white,
    )
  );
}