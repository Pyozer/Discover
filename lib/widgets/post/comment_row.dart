import 'package:discover/models/comments/comment.dart';
import 'package:discover/utils/api/api.dart';
import 'package:discover/utils/functions.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:discover/widgets/ui/custom_alert_dialog.dart';
import 'package:discover/widgets/user/user_image.dart';
import 'package:flutter/material.dart';

class CommentRow extends StatelessWidget {
  final Comment comment;
  final VoidCallback onDeleted;

  const CommentRow({Key key, @required this.comment, @required this.onDeleted})
      : super(key: key);

  Future<void> _deleteComment(BuildContext context) async {
    bool isOk = await showDialog(
      context: context,
      builder: (dialogCtx) {
        return CustomAlertDialog(
          title: "Delete comment",
          content: Text("Are you sure you want to delete this comment ?"),
          onNegative: () => Navigator.of(context).pop(false),
          onPositive: () => Navigator.of(context).pop(true),
        );
      },
    );
    if (isOk != true) return;

    try {
      final token = PreferencesProvider.of(context).getUser()?.token;
      await Api().deleteComment(comment.idPost, comment.id, token);
      onDeleted();
    } catch (e) {
      showErrorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = PreferencesProvider.of(context).getUser()?.id;

    return InkWell(
      onLongPress:
          comment.idUser == userId ? () => _deleteComment(context) : null,
      child: Container(
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          comment.userInfo,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        getTimeAgo(comment.date),
                        style: Theme.of(context).textTheme.caption,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Text(comment.text, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
