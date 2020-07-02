import 'package:flutter/material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/api_user_helper.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/tiles/user_tile.dart';

class FollowersSearchPage extends StatefulWidget {
  FollowersSearchState createState() => FollowersSearchState();
}

class FollowersSearchState extends State<FollowersSearchPage> {
  TextEditingController search;
  String myFilter="";
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
        PaddingWith(top: 20, widget: MyText("Mes abonnés",fontSize: 20,color: black,),),
        Divider(thickness: 1,),
        Expanded(
            child: FutureBuilder(
          future: ApiUserHelper().getMyFollowers(),
          builder:
              (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              List<User> documents = snapshot.data;
              if(documents.length<1){
                return Center(child: MyText("Aucun abonné",color: black,fontSize: 18,),);
              }
              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    User user = documents[index];
                    if (user.uid != me.uid&&(user.firstName.contains(myFilter)||user.lastName.contains(myFilter))) {
                      return UserTile(user,refresh);
                    }
                    else{
                      return SizedBox.shrink();
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

  refresh() {
    setState(() {});
  }

  void searchPerson(String input) {
    setState(() {
      myFilter=input;
    });
  }
}
