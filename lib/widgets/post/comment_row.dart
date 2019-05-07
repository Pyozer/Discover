import 'package:discover/models/comments/comment.dart';
import 'package:discover/widgets/user/user_image.dart';
import 'package:flutter/material.dart';

class CommentRow extends StatelessWidget {
  final Comment comment;

  const CommentRow({Key key, this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserImage(imageUrl: comment.photoUser, size: 50),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  comment.userInfo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 6.0),
                Text(
                  comment.textComment,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
