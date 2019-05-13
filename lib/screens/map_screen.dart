import 'package:after_layout/after_layout.dart';
import 'package:discover/models/posts/post.dart';
import 'package:discover/models/posts/sort_mode.dart';
import 'package:discover/screens/post_screen.dart';
import 'package:discover/utils/api/api.dart';
import 'package:discover/utils/functions.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final Position userPos;
  final SortMode sortMode;

  MapScreen({Key key, @required this.userPos, @required this.sortMode})
      : super(key: key);

  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with AfterLayoutMixin {
  List<Post> _posts = [];

  @override
  void afterFirstLayout(BuildContext coontext) {
    _fetchPosts();
  }

  @override
  void didUpdateWidget(MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isSamePos = widget.userPos.toString() == oldWidget.userPos.toString();
    final isSameSort = widget.sortMode == oldWidget.sortMode;
    if (!isSamePos || !isSameSort) _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final prefs = PreferencesProvider.of(context);
      final res = await Api().getPostsMaps(prefs.getUser()?.token);
      setState(() => _posts = res.posts ?? []);
    } catch (e) {
      showErrorDialog(context, e);
    }
  }

  Marker _buildMarker(Post post) {
    return Marker(
      position: LatLng(post.latitude, post.longitude),
      markerId: MarkerId("${post.id}"),
      infoWindow: InfoWindow(
        title: "Post by ${post.author.userInfo}",
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => PostScreen(postId: post.id),
          ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userPos = PreferencesProvider.of(context).getUserPos();
    final latLngUser = LatLng(userPos.latitude, userPos.longitude);

    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      markers: _posts.map(_buildMarker).toSet(),
      initialCameraPosition: CameraPosition(target: latLngUser, zoom: 14),
      onMapCreated: (GoogleMapController controller) {},
    );
  }
}
