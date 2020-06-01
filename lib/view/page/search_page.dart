import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_widgets/loadingCenter.dart';
import 'package:memories/view/tiles/user_tile.dart';

class SearchPage extends StatefulWidget {
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchPage> {

  TextEditingController search;

  @override
  void initState() {
    super.initState();
    search=TextEditingController();
  }

  @override
  void dispose() {
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
          child: PaddingWith(
            top: 50,
            left: 20,
            right: 20,
            widget :MySearchBar(
            controller: search ,
            labelText: 'Rechercher',
            hint: "Rechercher un profil",
            icon:Icons.search,
            obscure: false,
            onsubmitted: searchPerson,
          ),
        ),
        ),
        PaddingWith(
            top:20,
            widget :Text("Mes followers")),
        Expanded(child :StreamBuilder<QuerySnapshot>(
          stream: FireHelper().fire_user.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> documents = snapshot.data.documents;
              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    User user = User(documents[index]);
                    if(user.uid!=me.uid) {
                      return UserTile(user);
                    }
                    else{
                      return Container(height: 1,);
                    }
                  });
            } else {
              return LoadingCenter();
            }
          },
        ))
      ],
    );
  }
}

void searchPerson(String input){

}
