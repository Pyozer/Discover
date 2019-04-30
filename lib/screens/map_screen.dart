import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final kPosition = CameraPosition(
    target: LatLng(48.7886906, 2.3637846),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      markers: Set.from([
        Marker(
          position: kPosition.target,
          markerId: MarkerId("test")
        ),
      ]),
      initialCameraPosition: kPosition,
      onMapCreated: (GoogleMapController controller) {},
    );
  }
}
