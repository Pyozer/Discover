import 'package:discover/utils/api/api.dart';
import 'package:discover/utils/keys/string_key.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:discover/utils/translations.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final ValueChanged<bool> onTap;
  final ValueChanged<bool> onDone;
  final bool isLike;
  final int likesCount;
  final bool isSmall;
  final int postId;

  const LikeButton({
    Key key,
    this.onTap,
    this.onDone,
    @required this.isLike,
    this.isSmall = false,
    @required this.postId,
    @required this.likesCount,
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLike = false;
  int _likesCount = 0;

  @override
  void initState() {
    super.initState();
    _isLike = widget.isLike;
    _likesCount = widget.likesCount;
  }

  Future<void> _togglePostLike() async {
    if (widget.onTap != null) widget.onTap(_isLike);

    setState(() {
      _likesCount += _isLike ? -1 : 1;
      _isLike = !_isLike;
    });

    final prefs = PreferencesProvider.of(context);
    final response = await Api().likePost(
      widget.postId,
      prefs.getUser()?.token,
    );
    if (widget.onDone != null) widget.onDone(response.result);
  }

  @override
  Widget build(BuildContext context) {
    String text = '';
    if (!widget.isSmall) {
      text = i18n.text(_likesCount < 2 ? StrKey.like : StrKey.likes);
    }

    List<Widget> _elements = [
      Icon(
        Icons.favorite,
        size: widget.isSmall ? null : 35,
        color: _isLike ? Colors.red[600] : Colors.grey[700],
      ),
      widget.isSmall ? const SizedBox(width: 8.0) : const SizedBox(height: 8.0),
      Text(
        "$_likesCount$text",
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      )
    ];

    return GestureDetector(
      onTap: _togglePostLike,
      child: widget.isSmall
          ? Row(children: _elements)
          : Column(children: _elements),
    );
  }
}
