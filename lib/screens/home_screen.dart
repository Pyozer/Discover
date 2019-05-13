import 'package:discover/models/posts/sort_mode.dart';
import 'package:discover/screens/add_post_screen.dart';
import 'package:discover/screens/login_screen.dart';
import 'package:discover/screens/map_screen.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:discover/widgets/list/main_post_list.dart';
import 'package:discover/widgets/place_selector.dart';
import 'package:discover/widgets/user/user_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:after_layout/after_layout.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AfterLayoutMixin<HomeScreen> {
  final _listKey = GlobalKey<MainPostListState>();
  int _currentIndex = 0;

  @override
  void afterFirstLayout(BuildContext context) {
    if (PreferencesProvider.of(context).getUserPos() == null)
      _openLocationPicker();
  }

  Future<Geolocator.Position> _openLocationPicker() async {
    final userPos = await showDialog<Geolocator.Position>(
      context: context,
      builder: (dialogContext) =>
          PlaceSelector(onDone: Navigator.of(dialogContext).pop),
    );
    if (userPos == null) return null;
    return userPos;
  }

  @override
  Widget build(BuildContext context) {
    final prefs = PreferencesProvider.of(context);
    final user = prefs.getUser();

    return Scaffold(
      appBar: AppBar(
        title: Text("Discover"),
        actions: [
          PopupMenuButton<bool>(
            icon: const Icon(Icons.edit_location),
            onSelected: (isCustomPos) async {
              if (isCustomPos) {
                // If custom position choosed
                final userPos = await _openLocationPicker();
                if (userPos != null) {
                  // If popup not cancelled
                  prefs.setUserPosition(userPos);
                  prefs.setCustomPos(isCustomPos, true);
                  return;
                }
              }
              final gpsPos = await Geolocator.Geolocator().getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
              );
              prefs.setCustomPos(false);
              prefs.setUserPosition(gpsPos, true);
            },
            itemBuilder: (BuildContext context) {
              return [false, true].map((isCustomPos) {
                return CheckedPopupMenuItem<bool>(
                  checked: isCustomPos == prefs.isCustomPos(),
                  value: isCustomPos,
                  child:
                      Text(isCustomPos ? "Selected position" : "GPS Position"),
                );
              }).toList();
            },
          ),
          PopupMenuButton<SortMode>(
            icon: const Icon(Icons.sort),
            onSelected: (sortMode) {
              prefs.setSortMode(sortMode, true);
            },
            itemBuilder: (BuildContext context) {
              return SortMode.values.map((sortMode) {
                return CheckedPopupMenuItem<SortMode>(
                  checked: sortMode == prefs.getSortMode(),
                  value: sortMode,
                  child: Text("Sort by $sortMode"),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          prefs.getUserPos() == null
              ? Container()
              : Column(
                  children: [
                    prefs.isCustomPos()
                        ? Container(child: Text("Custom position selected"))
                        : const SizedBox.shrink(),
                    Expanded(
                      child: MainPostList(
                        key: _listKey,
                        userPos: prefs.getUserPos(),
                        sortMode: prefs.getSortMode(),
                      ),
                    ),
                  ],
                ),
          MapScreen(userPos: prefs.getUserPos(), sortMode: prefs.getSortMode()),
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
              enabled: false,
            ),
            ListTile(
              title: Text("Search user"),
              leading: Icon(Icons.search),
              enabled: false,
            ),
            const Divider(),
            ListTile(
              title: Text("About"),
              leading: Icon(Icons.info_outline),
              enabled: false,
            ),
            ListTile(
              title: Text("Introduction"),
              leading: Icon(Icons.view_carousel),
              enabled: false,
            ),
            ListTile(
              title: Text("Feedback"),
              leading: Icon(Icons.feedback),
              enabled: false,
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
