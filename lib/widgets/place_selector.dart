import 'package:discover/utils/keys/asset_key.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:discover/widgets/ui/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceSelector extends StatefulWidget {
  final ValueChanged<Position> onDone;

  PlaceSelector({Key key, @required this.onDone}) : super(key: key);

  _PlaceSelectorState createState() => _PlaceSelectorState();
}

class _PlaceSelectorState extends State<PlaceSelector> {
  LatLng _mapPosition;

  @override
  Widget build(BuildContext context) {
    final dialogWidth = MediaQuery.of(context).size.width - 40.0 * 2;
    final dialogHeight = 350.0;
    final iconSize = 35.0;

    final userPos = PreferencesProvider.of(context).getUserPos();

    if (userPos != null && _mapPosition == null)
      _mapPosition = LatLng(userPos.latitude, userPos.longitude);

    return CustomAlertDialog(
      title: "Choose your position",
      content: Stack(
        children: [
          Container(
            height: dialogHeight,
            width: dialogWidth,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _mapPosition,
                zoom: 15,
              ),
              onCameraMove: (cameraPos) {
                setState(() => _mapPosition = cameraPos.target);
              },
            ),
          ),
          Positioned(
            top: dialogHeight / 2 - iconSize,
            left: (dialogWidth - iconSize) / 2,
            child: Image.asset(
              AssetKey.marker,
              width: iconSize,
              height: iconSize,
            ),
          ),
        ],
      ),
      contentPadding: false,
      positiveBtn: "Submit",
      onPositive: () {
        widget.onDone(Position(
          latitude: _mapPosition.latitude,
          longitude: _mapPosition.longitude,
        ));
      },
      negativeBtn: "Cancel",
      onNegative: () => widget.onDone(null),
    );
  }
}
