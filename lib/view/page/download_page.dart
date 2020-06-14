import 'package:flutter/material.dart';
import 'package:memories/util/alert_helper.dart';
import 'package:memories/view/my_material.dart';

class DownloadPage extends StatefulWidget{
  DownLoadState createState() => DownLoadState();
}
class DownLoadState extends State<DownloadPage>{

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      AlertHelper().newVersion(context, "Une nouvelle version est disponible", "Voulez-vous la télécharger ?");
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: LoadingCenter(),

    );

  }


}