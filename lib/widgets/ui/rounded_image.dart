import 'package:discover/utils/keys/asset_key.dart';
import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  final String imageUrl;
  final String placeholder;
  final double radius;
  final double elevation;
  final Size size;

  const RoundedImage({
    Key key,
    @required this.imageUrl,
    this.placeholder = AssetKey.placeholderUser,
    this.radius = 100,
    this.elevation = 0,
    @required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(radius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: imageUrl == null
            ? Image.asset(
                placeholder,
                width: size.width,
                height: size.height,
                fit: BoxFit.cover,
              )
            : FadeInImage.assetNetwork(
                image: imageUrl,
                width: size.width,
                height: size.height,
                fit: BoxFit.cover,
                placeholder: placeholder,
              ),
      ),
    );
  }
}
