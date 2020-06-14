import 'package:clip_shadow/clip_shadow.dart';
import 'package:flutter/material.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/ui/my_clipper.dart';
import 'package:memories/view/ui/my_second_clipper.dart';

class MemoriesPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
             ClipShadow(
                  clipper: PrimaryClipper(),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 10,
                        offset: Offset(0.0, 1.0))
                  ],
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: (MediaQuery.of(context).size.height * (2 / 3)),
                    color: accent,
                  ),
                ),
              ClipShadow(
                  clipper: SecondClipper(),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 10,
                        offset: Offset(0.0, 1.0))
                  ],
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: (MediaQuery.of(context).size.height * (2 / 3)),
                    child: Container(
                      color: base.withOpacity(0.7),
                    ),
                  ),
                ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Center(
                  child: MyText(
                    "Memories",
                    color: white,
                    fontSize: 55,
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }


}