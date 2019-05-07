import 'package:discover/utils/keys/asset_key.dart';
import 'package:discover/widgets/ui/rounded_image.dart';
import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double elevation;

  const UserImage({
    Key key,
    @required this.imageUrl,
    @required this.size,
    this.elevation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedImage(
      imageUrl: imageUrl,
      size: Size.square(size),
      elevation: elevation,
      placeholder: AssetKey.placeholderUser,
    );
  }
}
