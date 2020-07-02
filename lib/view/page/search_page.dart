import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/my_widgets/loadingCenter.dart';
import 'package:memories/view/page/followers_search_page.dart';
import 'package:memories/view/page/following_search_page.dart';
import 'package:memories/view/page/query_search_page.dart';
import 'package:memories/view/tiles/user_tile.dart';

class SearchPage extends StatefulWidget {
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchPage> {
  int index = 0;
  var _pages;
  var _searchPageController = PageController();
  Future<QuerySnapshot> futureSearchResult;
  List<User> myQueryResult;


  @override
  void initState() {
    super.initState();
    _pages = [QuerySearchPage(),FollowersSearchPage(), FollowingSearchPage()];
  }

  @override
  void dispose() {
    _searchPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: PageView(
            controller: _searchPageController,
            onPageChanged: (index) {
              setState(() {
                this.index = index;
              });
            },
            children: _pages != null ? _pages : <Widget>[LoadingCenter()],
          ),
        ),
        PaddingWith(
          bottom: 25,
          widget :
        Indicator(
          controller: _searchPageController,
          itemCount: 3,
        ),
        ),
      ],
    );
  }


}
