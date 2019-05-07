import 'package:discover/widgets/user/user_image.dart';
import 'package:flutter/material.dart';

class CommentRow extends StatelessWidget {
  final int userId;
  final String username; 
  final String comment; 

  const CommentRow({Key key, this.userId, this.username, this.comment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserImage(userId: userId, size: 50),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 13),
                  maxLines: 1,
                ),
                const SizedBox(height: 6.0),
                Text(comment, style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
