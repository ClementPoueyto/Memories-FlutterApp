import 'package:flutter/material.dart';

///Element de décoration accueil Memories Page
class SecondClipper extends CustomClipper<Path> {
@override
Path getClip(Size size) {
  // TODO: implement getClip

  var path = new Path();
  path.lineTo(0, size.height /1.1);
  var firstControlPoint = new Offset(size.width / 6, size.height );
  var firstEndPoint = new Offset(size.width / 2.85, size.height/1.1);
  var secondControlPoint = new Offset(size.width / 2 + 40, size.height/1.3);
  var secondEndPoint = new Offset(size.width - (size.width / 4), size.height/1.1 );

  var thirdControlPoint = new Offset(size.width - 20, size.height );
  var thirdEndPoint = new Offset(size.width, size.height/1.1 );

  path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
      firstEndPoint.dx, firstEndPoint.dy);
  path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
      secondEndPoint.dx, secondEndPoint.dy);
  path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
      thirdEndPoint.dx, thirdEndPoint.dy);

  path.lineTo(size.width, size.height / 4);
  path.lineTo(size.width, 0);
  path.close();
  return path;
}

@override
bool shouldReclip(CustomClipper oldClipper) => false;

}