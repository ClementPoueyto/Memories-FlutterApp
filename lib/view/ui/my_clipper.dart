import 'package:flutter/material.dart';

class PrimaryClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    // TODO: implement getClip
    var path = new Path();
    path.lineTo(0, size.height /1);
    var firstControlPoint = new Offset(size.width / 4, size.height / 1.25);
    var firstEndPoint = new Offset(size.width / 2, size.height /1.1);
    var secondControlPoint = new Offset(size.width - (size.width / 4), size.height );
    var secondEndPoint = new Offset(size.width, size.height / 1.2 );

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 1.25);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper)
  {
    return false;
  }
}