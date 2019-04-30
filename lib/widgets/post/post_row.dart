import 'package:discover/screens/post_screen.dart';
import 'package:discover/widgets/ui/rounded_image.dart';
import 'package:discover/widgets/user/user_image.dart';
import 'package:flutter/material.dart';

enum MenuPost { report }

const img = "http://images.unsplash.com/photo-1555985202-12975b0235dc";

class PostRow extends StatelessWidget {
  const PostRow({Key key}) : super(key: key);

  Widget _buildReportBtn(BuildContext context) {
    return PopupMenuButton<MenuPost>(
      icon: Icon(Icons.more_vert),
      onSelected: (MenuPost result) {
        // TODO: Report post
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuPost>>[
            const PopupMenuItem<MenuPost>(
              value: MenuPost.report,
              child: Text('Report'),
            ),
          ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 0, 14),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  UserImage(userId: "fdghj-dfgh-dfgh-fdgh", size: 50),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Username",
                              style: textTheme.title.copyWith(fontSize: 14.0),
                            ),
                            const SizedBox(width: 4.0),
                            Text("• 21 hours", style: textTheme.caption),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text("150m", style: textTheme.body1)
                      ],
                    ),
                  ),
                  _buildReportBtn(context),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => PostScreen()));
            },
            child: RoundedImage(
              imageUrl: img,
              size: Size.fromHeight(250),
              radius: 0.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16.0, 16.0, 0.0),
            child: Text("Wesh ca va ?"),
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
                      Text("0")
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
                      Text("0")
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
