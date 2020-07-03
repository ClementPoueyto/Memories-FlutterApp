import 'package:memories/controller/add_post_controller.dart';
import 'package:memories/models/notification.dart';
import 'package:memories/models/post.dart';
import 'package:memories/util/api_notif_helper.dart';
import 'package:memories/util/api_post_helper.dart';
import 'package:flutter/material.dart';
import 'package:memories/view/my_material.dart';
import 'package:memories/view/page/feed_page.dart';
import 'package:memories/view/page/notification_page.dart';
import 'package:memories/view/page/profile_page.dart';
import 'package:memories/view/page/search_page.dart';

class MainAppController extends StatefulWidget {
  final String uid;
  MainAppController(this.uid);
  _MainState createState() => _MainState();
}

class _MainState extends State<MainAppController> {
  bool _isNotified;
  int index = 0;

  final ValueNotifier<List<Post>> notifierFeedPosts = new ValueNotifier([]);
  final ValueNotifier<List<Notif>> notifierFeedNotifs = new ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    initApp();
  }
  @override
  void dispose() {
    super.dispose();
  }

  initApp() {
    //FETCH DATA
    List<String> usersIdToFetchData=me.following;
    usersIdToFetchData.add(me.uid);
    ApiPostHelper().getMyFeed(usersIdToFetchData).then((value) => {
      notifierFeedPosts.value =value
    });

    ApiNotifHelper().getMyNotifs().then((value) => {
      notifierFeedNotifs.value=value
    });

    _isNotified = false;
    notifierFeedNotifs.addListener(() {
      feedNotifSave = notifierFeedNotifs.value;
      isNotified(notifierFeedNotifs.value);
    });
    notifierFeedPosts.addListener(() {
      feedPostSave = this.notifierFeedPosts.value;
    });
  }

  bool isNotified(List<Notif> notifs) {
    setState(() {
      bool _shouldBeNotified = false;
      notifs.forEach((myNotif) {
        if (!myNotif.seen) {
          _shouldBeNotified = true;
        }
      });
      if (_shouldBeNotified == true) {
        _isNotified = true;
      } else {
        _isNotified = false;
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return (me == null)
        ? LoadingScaffold()
        : Scaffold(
            endDrawer: MyDrawer(
              user: me,
              context: context,
            ),
            bottomNavigationBar: BottomBar(
              color: whiteShadow,
              items: [
                BarItem(
                  icon: homeIcon,
                  onPressed: (() => buttonSelected(0)),
                  selected: index == 0,
                ),
                BarItem(
                  icon: searchIcon,
                  onPressed: (() => buttonSelected(1)),
                  selected: index == 1,
                ),
                SizedBox(),
                BarItem(
                  icon: profileIcon,
                  onPressed: (() => buttonSelected(2)),
                  selected: index == 2,
                ),
                BarItem(
                  icon: _isNotified
                      ? Icon(Icons.notifications_active)
                      : notificationIcon,
                  onPressed: (() => buttonSelected(3)),
                  selected: index == 3,
                )
              ],
              shapeCircular: true,
            ),
            body: GestureDetector(
                onTap: hideKeyBoard,
                child: Container(
                    height: MediaQuery.of(context).size.height - kToolbarHeight,
                    child: showPage())),
            backgroundColor: whiteShadow,
            floatingActionButton: FloatingActionButton(
              onPressed: pushAddPost,
              child: addIcon,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
  }

  pushAddPost() {
     Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddPost(null,this.notifierFeedPosts)));

  }

  buttonSelected(int index) {
    setState(() {
      this.index = index;
    });
  }

  void hideKeyBoard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Widget showPage() {
    switch (index) {
      case 0:
        return FeedPage(me,this.notifierFeedPosts);
      case 1:
        return SearchPage(this.notifierFeedPosts);
      case 2:
        return ProfilePage(me,this.notifierFeedPosts);
      case 3:
        return NotificationPage(this.notifierFeedPosts,this.notifierFeedNotifs);
    }
  }

}
