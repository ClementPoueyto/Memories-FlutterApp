import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/tiles/user_tile.dart';

class QuerySearchPage extends StatefulWidget {
  QuerySearchState createState() => QuerySearchState();
}

class QuerySearchState extends State<QuerySearchPage> {
  TextEditingController search;
  String myFilter = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    search = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: BoxDecoration(color: base),
          child: PaddingWith(
            top: 50,
            left: 20,
            right: 20,
            widget: MySearchBar(
              controller: search,
              labelText: 'Rechercher',
              hint: "Rechercher un profil",
              icon: Icons.search,
              obscure: false,
              onChanged: searchPerson,
            ),
          ),
        ),
        PaddingWith(
          top: 20,
          widget: MyText(
            "Ma recherche",
            fontSize: 20,
            color: black,
          ),
        ),
        Divider(
          thickness: 1,
        ),
        Expanded(
            child: myFilter == ""
                ? Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Column(
                        children: <Widget>[
                          Center(child: PaddingWith(
                            bottom: 20,
                            top: 0,
                            widget: MyText("Rechercher un utilisateur par son pseudo",color: Colors.grey,),),),
                          Image(
                            width: 100,
                            height: 100,
                            image: searchImage,
                          )
                        ],
                      ),
                    ),
                  )
                : StreamBuilder<QuerySnapshot>(
                    stream: FireHelper()
                        .fire_user
                        .where(keyPseudo,
                            isEqualTo: myFilter.toLowerCase().trim())
                        .limit(20)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.documents.length == 0) {
                          return Center(
                            child: MyText(
                              "Aucun utilisateur",
                              color: black,
                              fontSize: 25,
                            ),
                          );
                        }
                        List<User> myquery = [];
                        snapshot.data.documents.forEach(
                          (u) {
                            User user = User(u);
                            myquery.add(user);
                          },
                        );
                        return ListView.builder(
                          itemCount: myquery.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            User user = myquery[index];
                            if (user.uid != me.uid) {
                              return UserTile(user);
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  )),
      ],
    );
  }

  void searchPerson(String input) {
    setState(() {
      myFilter = input;
    });
  }
}
