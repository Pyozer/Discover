import 'package:discover/widgets/rounded_image.dart';
import 'package:flutter/material.dart';

enum MenuPost { report }

class PostRow extends StatelessWidget {
  const PostRow({Key key}) : super(key: key);

  Widget _buildReportBtn(BuildContext context) {
    return PopupMenuButton<MenuPost>(
      icon: Icon(Icons.more_vert),
      onSelected: (MenuPost result) {
        // TODO: report post
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
                  RoundedImage(
                    imageUrl:
                        "https://www.beachfitbondi.com.au/wp-content/uploads/2017/12/placeholder-profile.jpg",
                    size: Size.square(50),
                  ),
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
          RoundedImage(
            imageUrl:
                "https://images.unsplash.com/photo-1469827160215-9d29e96e72f4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",
            size: Size.fromHeight(250),
            radius: 0.0,
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
