import 'package:discover/models/posts/post.dart';
import 'package:discover/screens/post_screen.dart';
import 'package:discover/utils/functions.dart';
import 'package:discover/widgets/ui/rounded_image.dart';
import 'package:discover/widgets/user/user_image.dart';
import 'package:flutter/material.dart';

enum MenuPost { report }

const img = "http://images.unsplash.com/photo-1555985202-12975b0235dc";

class PostRow extends StatelessWidget {
  final Post post;

  const PostRow({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final author = post.authorPost;

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
                  UserImage(userId: 23, size: 40),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "${author.firstNameUser} ${author.lastNameUser}",
                          style: textTheme.title.copyWith(fontSize: 15.0),
                        ),
                        const SizedBox(height: 6.0),
                        Text("150m", style: textTheme.caption)
                      ],
                    ),
                  ),
                  Text(getTimeAgo(post.datePost), style: textTheme.caption),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PostScreen(postId: post.idPost)),
              );
            },
            child: RoundedImage(
              imageUrl: img,
              size: Size.fromHeight(250),
              radius: 0.0,
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
                      GestureDetector(
                        child: Icon(Icons.favorite, color: Colors.grey[800]),
                        onTap: () {},
                      ),
                      const SizedBox(width: 10.0),
                      Text(post.likesPost.toString())
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child:
                            Icon(Icons.mode_comment, color: Colors.grey[800]),
                        onTap: () {},
                      ),
                      const SizedBox(width: 10.0),
                      Text(post.commentsPost.toString())
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
