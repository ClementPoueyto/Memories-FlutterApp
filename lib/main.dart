import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/page/memories_page.dart';
import 'controller/main_app_controller.dart';
import 'controller/log_controller.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:memories/view/page/download_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memories',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: _handleAuth(),
    );
  }

  Widget _handleAuth() {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (BuildContext context, package) {
        if (!package.hasData) {
          return MemoriesPage();
        } else {
          return FutureBuilder(
            future: FireHelper().fire_app.document("memories").get(),
            builder: (BuildContext context, doc) {
              if (!doc.hasData) {
                return MemoriesPage();
              } else {
                if (doc.data["version"]
                    .contains(package.data.version.toString())) {
                  return StreamBuilder<FirebaseUser>(
                      stream: FirebaseAuth.instance.onAuthStateChanged,
                      builder: (BuildContext context, snapshot) {
                        bool timer= false;
                        return (snapshot.hasData && snapshot.data.uid != null)
                            ? MainAppController(snapshot.data.uid)
                            : FutureBuilder(
                                future: Future.delayed(
                                  Duration(milliseconds: 100),(){
                                    timer=true;
                                }),
                                builder: (BuildContext context, duration) {
                                  if(timer) {
                                    return LogController();
                                  }
                                  else{
                                    return MemoriesPage();
                                  }
                                });
                      });
                } else {
                  return DownloadPage();
                }
              }
            },
          );
        }
      },
    );
  }
}
