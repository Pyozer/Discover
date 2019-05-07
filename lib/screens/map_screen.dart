import 'package:discover/models/posts/post.dart';
import 'package:discover/utils/api/api.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Post> _posts = [];

  final kPosition = CameraPosition(
    target: LatLng(48.7886906, 2.3637846),
    zoom: 14,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchPost();
  }

  Future<void> _fetchPost() async {
    final prefs = PreferencesProvider.of(context);
    final res = await Api().getPostsMaps(prefs.getUser()?.token);
    setState(() => _posts = res.posts ?? []);
  }

  Marker _buildMarker(Post post) {
    return Marker(
      position: LatLng(post.latitude, post.longitude),
      markerId: MarkerId("${post.id}"),
      infoWindow: InfoWindow(title: "Post by ${post.author.userInfo}"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      markers: _posts.map(_buildMarker).toSet(),
      initialCameraPosition: kPosition,
      onMapCreated: (GoogleMapController controller) {},
    );
  }
}
