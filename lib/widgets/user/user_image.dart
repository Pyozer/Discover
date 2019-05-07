import 'package:discover/widgets/ui/rounded_image.dart';
import 'package:flutter/material.dart';

const kDefaultImg =
    "https://www.beachfitbondi.com.au/wp-content/uploads/2017/12/placeholder-profile.jpg";

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
      imageUrl: imageUrl ?? kDefaultImg,
      size: Size.square(size),
      elevation: elevation,
    );
  }
}
