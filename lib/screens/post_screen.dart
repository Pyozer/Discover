import 'package:discover/models/comments/comment.dart';
import 'package:discover/models/comments/request/comment_payload.dart';
import 'package:discover/models/fetch_data.dart';
import 'package:discover/models/posts/post.dart';
import 'package:discover/models/tags/tag.dart';
import 'package:discover/utils/api/api.dart';
import 'package:discover/utils/functions.dart';
import 'package:discover/utils/keys/asset_key.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:discover/widgets/like_button.dart';
import 'package:discover/widgets/post/comment_row.dart';
import 'package:discover/widgets/ui/custom_alert_dialog.dart';
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
  final _fetch = FetchData<Post>();
  final _fetchComments = FetchData<List<Comment>>();
  final _commentController = TextEditingController();
  final _commentTextFocus = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchPost();
    _fetchAllComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentTextFocus.dispose();
    super.dispose();
  }

  Future<void> _fetchPost() async {
    if (!mounted || _fetch.isLoading) return;
    setState(() => _fetch.isLoading = true);
    try {
      final prefs = PreferencesProvider.of(context);
      final response = await Api().getPost(
        widget.postId,
        prefs.getUserPos(),
        prefs.getUser()?.token,
      );
      _fetch.data = response.posts?.first;
    } catch (e) {
      _fetch.error = e;
    }
    if (!mounted) return;
    setState(() => _fetch.isLoading = false);
  }

  Future<void> _fetchAllComments() async {
    if (!mounted) return;
    setState(() => _fetchComments.isLoading = true);
    try {
      final response = await Api().getComments(
        widget.postId,
        PreferencesProvider.of(context).getUser()?.token,
      );
      _fetchComments.data = response.comments;
    } catch (e) {
      _fetchComments.error = e;
    }
    if (!mounted) return;
    setState(() => _fetchComments.isLoading = false);
  }

  Future<void> _sendComment() async {
    if (!mounted) return;
    final comment = _commentController.text.trim();
    _commentController.clear();
    setState(() {
      _fetchComments.data = null;
      _fetchComments.isLoading = true;
    });
    try {
      await Api().addComment(
        widget.postId,
        CommentPayLoad(text: comment),
        PreferencesProvider.of(context).getUser()?.token,
      );
      _fetchAllComments();
    } catch (e) {
      showErrorDialog(context, e);
    }
  }

  Future<void> _deletePost() async {
    bool isOk = await showDialog(
      context: context,
      builder: (dialogCtx) {
        return CustomAlertDialog(
          title: "Delete post",
          content: Text("Are you sure you want to delete this post ?"),
          onNegative: () => Navigator.of(context).pop(false),
          onPositive: () => Navigator.of(context).pop(true),
        );
      },
    );
    if (isOk != true) return;

    try {
      final token = PreferencesProvider.of(context).getUser()?.token;
      final res = await Api().deletePost(_fetch.data.id, token);
      if (res.result) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      showErrorDialog(context, e);
    }
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

  Chip _buildChip(Tag tag) {
    return Chip(
      elevation: 3,
      label: Text(tag.name, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.grey[600],
    );
  }

  Widget _buildComments() {
    if (!_fetchComments.hasData && _fetchComments.isLoading) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_fetchComments.hasError || !_fetchComments.hasData) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(_fetchComments.error?.toString() ?? "No comments"),
      );
    }
    return Column(
      children: _fetchComments.data
          .map((comment) => CommentRow(
                comment: comment,
                onDeleted: _fetchAllComments,
              ))
          .toList(),
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
            Hero(
              tag: post.id,
              child: FadeInImage.assetNetwork(
                image: post.photo,
                fit: BoxFit.cover,
                height: screenSize.height / 3.5,
                width: screenSize.width,
                placeholder: AssetKey.placeholderPost,
              ),
            ),
            AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions:
                  post.author.id == PreferencesProvider.of(context).getUser().id
                      ? [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: _deletePost,
                          )
                        ]
                      : [],
            ),
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
                                imageUrl: post.author.photo,
                                size: 50,
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Text(
                                  post.author.userInfo,
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Text("Description", style: textTheme.caption),
                          const SizedBox(height: 8.0),
                          Text(post.content),
                          const SizedBox(height: 20.0),
                          Text("Tags", style: textTheme.caption),
                          const SizedBox(height: 4.0),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: -5.0,
                            children: post.tags.map(_buildChip).toList(),
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
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                            child: Text("COMMENTS", style: textTheme.caption),
                          ),
                          TextField(
                            controller: _commentController,
                            focusNode: _commentTextFocus,
                            minLines: 1,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: 'Enter your comment',
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: _sendComment,
                              ),
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
                                postId: post.id,
                                likesCount: post.likes,
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
                                text: "${post.comments} comments",
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(_commentTextFocus);
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
