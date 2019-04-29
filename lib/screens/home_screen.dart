import 'package:discover/widgets/main_post_list.dart';
import 'package:discover/widgets/user_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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
          MainPostList(),
          MainPostList(),
          MainPostList(),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(height: 24.0),
            Center(
              child: UserImage(
                userId: "fgh-dfgh-fgh-fgh",
                size: 125,
                elevation: 2.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              "FirstName LastName",
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30.0),
            ListTile(
              title: Text("My Account"),
              leading: Icon(Icons.person),
              onTap: () {},
            ),
            ListTile(
              title: Text("Search user"),
              leading: Icon(Icons.search),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: Text("About"),
              leading: Icon(Icons.info_outline),
              onTap: () {},
            ),
            ListTile(
              title: Text("Introduction"),
              leading: Icon(Icons.view_carousel),
              onTap: () {},
            ),
            ListTile(
              title: Text("Feedback"),
              leading: Icon(Icons.feedback),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.exit_to_app),
              onTap: () {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (page) {
          setState(() => _currentIndex = page);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            title: Text("All posts"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text("Friends posts"),
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
