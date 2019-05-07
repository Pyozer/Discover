import 'package:discover/models/comments/comments_response.dart';
import 'package:discover/models/fetch_data.dart';
import 'package:discover/models/posts/post.dart';
import 'package:discover/utils/api/api.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:discover/widgets/like_button.dart';
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
  FetchData<Post> _fetch = FetchData<Post>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchPost();
  }

  Future<void> _fetchPost() async {
    setState(() => _fetch.isLoading = true);

    try {
      final prefs = PreferencesProvider.of(context);
      final response = await Api().getPost(
        widget.postId,
        prefs.getUserPos(),
        prefs.getUser()?.tokenUser,
      );

      _fetch.data = response.posts?.first;
    } catch (e) {
      _fetch.error = e;
    }

    setState(() => _fetch.isLoading = false);
  }

  Future<CommentsResponse> _fetchComment() async {
    final prefs = PreferencesProvider.of(context);
    return await Api().getComments(
      widget.postId,
      prefs.getUser()?.tokenUser,
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

  Widget _buildComments() {
    return FutureBuilder<CommentsResponse>(
      future: _fetchComment(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        if (snap.hasError || (snap.data.comments?.isEmpty ?? true))
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(snap.error?.toString() ?? "No comments"),
          );
        return Column(
          children: snap.data.comments
              .map((comment) => CommentRow(comment: comment))
              .toList(),
        );
      },
    );
  }

  Widget _buildContent() {
    final screenSize = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    if (!_fetch.hasData && _fetch.isLoading)
      return const Center(child: CircularProgressIndicator());
    if (_fetch.hasError) return Center(child: Text(_fetch.error.toString()));
    if (!_fetch.hasData) return const Center(child: Text("Empty"));
    final post = _fetch.data;

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
              Positioned.fill(
                top: 130,
                child: ListView(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 48),
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
                                imageUrl: post.authorPost.photoUser,
                                size: 50,
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Text(
                                  post.authorPost.userInfo,
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
                            children: post.tags
                                .map((t) => _buildChip(t.nomTag))
                                .toList(),
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
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                            child: Text(
                              "Commentaires".toUpperCase(),
                              style: textTheme.caption,
                            ),
                          ),
                          _buildComments(),
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
                        "Posted ${post.dateAgo}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: LikeButton(
                                isLike: post.isUserLike,
                                postId: post.idPost,
                                likesCount: post.likesPost,
                                onTap: (like) {
                                  setState(() => _fetch.data.isUserLike = like);
                                },
                                onDone: (_) => _fetchPost(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: _buildHeaderIcon(
                                icon: Icons.mode_comment,
                                text: "${post.commentsPost} comments",
                                onTap: () {
                                  //TODO: Focus add comment textfield
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: _buildHeaderIcon(
                                icon: Icons.directions,
                                text: post.distanceStr,
                                onTap: () {
                                  // TODO: Open map app
                                },
                              ),
                            ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildContent());
  }
}
