import 'package:discover/screens/add_post_screen.dart';
import 'package:discover/screens/login_screen.dart';
import 'package:discover/screens/map_screen.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:discover/widgets/list/main_post_list.dart';
import 'package:discover/widgets/user/user_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _listKey = GlobalKey<MainPostListState>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = PreferencesProvider.of(context).getUser();
    return Scaffold(
      appBar: AppBar(
        title: Text("Discover"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_location),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          MainPostList(key: _listKey),
          MapScreen(),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(height: 24.0),
            Center(
              child: UserImage(imageUrl: user.photo, size: 125, elevation: 2),
            ),
            const SizedBox(height: 16.0),
            Text(
              user.userInfo,
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30.0),
            ListTile(
              title: Text("My Account"),
              leading: Icon(Icons.person),
            ),
            ListTile(
              title: Text("Search user"),
              leading: Icon(Icons.search),
            ),
            const Divider(),
            ListTile(
              title: Text("About"),
              leading: Icon(Icons.info_outline),
            ),
            ListTile(
              title: Text("Introduction"),
              leading: Icon(Icons.view_carousel),
            ),
            ListTile(
              title: Text("Feedback"),
              leading: Icon(Icons.feedback),
            ),
            const Divider(),
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (_) => true,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AddPostScreen()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (page) {
          if (_currentIndex == page && page == 0)
            _listKey.currentState?.goToTop();
          else if (_currentIndex != page) setState(() => _currentIndex = page);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            title: Text("All posts"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text("Map"),
          ),
        ],
      ),
    );
  }
}
