import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/api_user_helper.dart';
import 'package:memories/util/api_version_helper.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/page/memories_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/main_app_controller.dart';
import 'controller/log_controller.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:memories/view/page/download_page.dart';

///Execution du programme
///MAIN
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatefulWidget {
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Future<User> user;
  Future<dynamic> token;
  Future packageInfo;
  Future versions;
  @override
  void initState() {
    super.initState();
    this.packageInfo = PackageInfo.fromPlatform();
    this.versions =ApiVersionHelper().getAllowedVersions();
    SharedPreferences.getInstance().then((sp) => {
      if(sp !=null&&sp.containsKey('token')&&sp.getString('token')!=null){
        token = ApiUserHelper().getNewToken(sp.getString('token')),
        token.then((token) => {
           FireHelper().auth_instance.signInWithEmailAndPassword(
            email: 'test@test.fr', password: 'testtest'),
          user =ApiUserHelper().getMyProfile(),
          user.then((value) => me=value)
        })

      }
    });
  }
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
      future: packageInfo,
      builder: (BuildContext context, package) {
        if (!package.hasData) {
          return MemoriesPage();
        } else {
          return FutureBuilder(
            future: versions,
            builder: (BuildContext context, doc) {
              if (!doc.hasData) {
                return MemoriesPage();
              } else {
                if (doc.data
                    .contains(package.data.version.toString())) {
                  return FutureBuilder(
                      future: user,
                      builder: (BuildContext context, snapshot) {
                        bool timer= false;
                        return (snapshot.hasData&&snapshot.data.uid!=null)
                            ? MainAppController(snapshot.data.uid)
                            : FutureBuilder(
                            future: Future.delayed(
                                Duration(milliseconds: 200),(){
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


