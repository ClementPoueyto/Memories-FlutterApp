import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memories/models/post.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/util/fire_helper.dart';
import 'package:memories/view/my_widgets/loadingCenter.dart';
import 'package:memories/view/page/profile_map_page.dart';
import 'package:memories/view/page/profile_posts_page.dart';
import 'package:memories/view/page/profile_tags_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  ProfilePage(this.user);

  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  bool _isme = false;
  int index = 0;
  var _pages;
  var _pageController = PageController();

  Map<Months, List<Post>> list;

  List<DocumentSnapshot> documents;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        BottomBar(
          items: [
            BarItem(
              icon: postIcon,
              onPressed: (() => buttonSelected(0)),
              selected: index == 0,
            ),
            BarItem(
              icon: place,
              onPressed: (() => buttonSelected(1)),
              selected: index == 1,
            ),
            BarItem(
              icon: tagIcon,
              onPressed: (() => buttonSelected(2)),
              selected: index == 2,
            ),
          ],
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: StreamBuilder<QuerySnapshot>(
                stream: FireHelper().postsFrom(widget.user.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return LoadingCenter();
                  } else {
                    documents = snapshot.data.documents;
                    sortPosts(documents);
                    _pages = [
                      ProfilePostsPage(this._isme,widget.user,documents, this.list),
                      ProfileMapPage(this.list),
                      ProfileTagsPage()
                    ];
                    return PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          this.index = index;
                        });
                      },
                      children:
                          _pages != null ? _pages : <Widget>[LoadingCenter()],
                    );
                  }
                })),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isme = (widget.user.uid == me.uid);

  }

  @override
  void dispose() {
    if (_pageController != null) {
      _pageController.dispose();
    }
    super.dispose();
  }

  void buttonSelected(int pageSelected) {
    setState(() {
      _pageController.animateToPage(pageSelected,
          duration: Duration(milliseconds: 200), curve: Curves.linear);
      this.index = pageSelected;
    });
  }

  void sortPosts(List<DocumentSnapshot> docs){
   list={
    Months.january : [],
    Months.february : [],
    Months.march : [],
    Months.april : [],
    Months.may : [],
    Months.june : [],
    Months.july : [],
    Months.august : [],
    Months.september : [],
    Months.october : [],
    Months.november : [],
    Months.december : [],
    };
    docs.sort((a,b) {
      DateTime adate = a.data[keyDate].toDate();
      DateTime bdate = b.data[keyDate].toDate();
      return bdate.compareTo(adate);
    });
    for(DocumentSnapshot doc in docs){
      DateTime date = doc.data[keyDate].toDate();
      this.list[Months.values[date.month-1]].add(Post(doc));
    }
  }
}
