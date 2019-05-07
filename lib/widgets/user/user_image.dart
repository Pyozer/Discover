import 'package:discover/widgets/ui/rounded_image.dart';
import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  final int userId;
  final double size;
  final double elevation;

  const UserImage(
      {Key key, @required this.userId, @required this.size, this.elevation = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Use real api link to get user image
    return RoundedImage(
      imageUrl:
          "https://www.beachfitbondi.com.au/wp-content/uploads/2017/12/placeholder-profile.jpg",
      size: Size.square(size),
      elevation: elevation,
    );
  }
}
