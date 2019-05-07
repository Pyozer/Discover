import 'package:discover/models/posts/post.dart';
import 'package:discover/screens/post_screen.dart';
import 'package:discover/widgets/like_button.dart';
import 'package:discover/widgets/user/user_image.dart';
import 'package:flutter/material.dart';

enum MenuPost { report }

class PostRow extends StatelessWidget {
  final Post post;

  const PostRow({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final author = post.author;

    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserImage(imageUrl: author.photo, size: 40),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          author.userInfo,
                          style: textTheme.title.copyWith(fontSize: 15.0),
                        ),
                        const SizedBox(height: 6.0),
                        Text(post.distanceStr, style: textTheme.caption)
                      ],
                    ),
                  ),
                  Text(post.dateAgo, style: textTheme.caption),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PostScreen(postId: post.id),
                ),
              );
            },
            child: FadeInImage.assetNetwork(
              image: post.photo,
              height: 250,
              placeholder: "assets/images/placeholder_post.png",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LikeButton(
                        isLike: post.isUserLike,
                        postId: post.id,
                        likesCount: post.likes,
                        isSmall: true,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.mode_comment,
                          color: Colors.grey[800],
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(width: 10.0),
                      Text(post.comments.toString())
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
