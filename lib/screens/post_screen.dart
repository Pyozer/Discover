import 'package:discover/models/posts/posts_response.dart';
import 'package:discover/utils/api/api.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:discover/widgets/post/comment_row.dart';
import 'package:discover/widgets/ui/custom_card.dart';
import 'package:discover/widgets/user/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class PostScreen extends StatefulWidget {
  final int postId;

  PostScreen({Key key, this.postId}) : super(key: key);

  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Future<PostsResponse> _fetchPost() async {
    return await Api().getPost(
      widget.postId,
      PreferencesProvider.of(context).getUser()?.tokenUser,
    );
  }

  Widget _buildHeaderIcon({
    IconData icon,
    Color color,
    String text,
    VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 35, color: color ?? Colors.grey[700]),
          const SizedBox(height: 8.0),
          Text(
            text.toUpperCase(),
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ],
      ),
    );
  }

  Chip _buildChip(String tag) {
    return Chip(
      elevation: 3,
      label: Text(tag, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.grey[600],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: FutureBuilder<PostsResponse>(
        future: _fetchPost(),
        builder: (context, snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text(snap.error.toString()));
          if (snap.data.posts?.isEmpty ?? true)
            return Center(child: Text("Empty"));
          final post = snap.data.posts.first;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Image.network(
                    post.photoPost,
                    fit: BoxFit.cover,
                    height: screenSize.height / 3.5,
                    width: screenSize.width,
                  ),
                  AppBar(elevation: 0, backgroundColor: Colors.transparent),
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      top: 130,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ListView(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 0),
                        children: [
                          CustomCard(
                            margin: EdgeInsets.only(bottom: 10.0),
                            radius: 0.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    UserImage(
                                      userId: post.authorPost.idUser,
                                      size: 50,
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: Text(
                                        post.authorPost.firstNameUser + " " + post.authorPost.lastNameUser,
                                        style: const TextStyle(fontSize: 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                Text("Description", style: textTheme.caption),
                                const SizedBox(height: 8.0),
                                Text(post.contentPost),
                                const SizedBox(height: 20.0),
                                Text("Tags", style: textTheme.caption),
                                const SizedBox(height: 4.0),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: -5.0,
                                  children: [
                                    _buildChip("Monument"),
                                    _buildChip("Paysage"),
                                    _buildChip("Randonnée"),
                                    _buildChip("Plage"),
                                    _buildChip("Visite"),
                                  ],
                                )
                              ],
                            ),
                          ),
                          CustomCard(
                            radius: 0.0,
                            padding: EdgeInsets.all(0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 16, 4),
                                  child: Text(
                                    "Commentaires".toUpperCase(),
                                    style: textTheme.caption,
                                  ),
                                ),
                                CommentRow(
                                  userId: 23,
                                  username: "Albert Reporter",
                                  comment:
                                      "Un super commentaire vraiment utile !",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomCard(
                      radius: 0.0,
                      padding: EdgeInsets.all(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            color: Colors.grey[200],
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Posted ${post.datePost.toString()}",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildHeaderIcon(
                                  icon: Icons.favorite,
                                  color: Colors.red[600],
                                  text: "${post.likesPost} likes",
                                  onTap: () {},
                                ),
                                _buildHeaderIcon(
                                  icon: Icons.mode_comment,
                                  text: "${post.commentsPost} comments",
                                  onTap: () {},
                                ),
                                _buildHeaderIcon(
                                  icon: Icons.directions,
                                  text: "183km",
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
