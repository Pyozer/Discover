import 'package:discover/models/posts/posts_response.dart';
import 'package:discover/models/posts/request/posts_location_payload.dart';
import 'package:discover/utils/api/api.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:discover/widgets/post/post_row.dart';
import 'package:flutter/material.dart';

class MainPostList extends StatefulWidget {
  MainPostList({Key key}) : super(key: key);

  @override
  MainPostListState createState() => MainPostListState();
}

class MainPostListState extends State<MainPostList> {
  final ScrollController _controller = ScrollController();

  Future<PostsResponse> _fetchPosts() async {
    final prefs = PreferencesProvider.of(context);
    final response = await Api().getPostByLocation(
      PostsLocationPayload(
        latitude: 48.6470509,
        longitude: 48.6470509,
        distance: 200000,
        tags: [],
      ),
      prefs.getUser()?.tokenUser,
    );
    return response;
  }

  Future<void> goToTop() {
    return _controller.animateTo(
      0,
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostsResponse>(
      future: _fetchPosts(),
      builder: (_, snap) {
        if (snap.hasError) return Center(child: Text(snap.error.toString()));
        if (!snap.hasData) return Center(child: CircularProgressIndicator());
        if (snap.data.posts?.isEmpty ?? true)
          return Center(child: Text("Empty"));

        return ListView.builder(
          controller: _controller,
          itemCount: snap.data.posts.length,
          itemBuilder: (context, i) => PostRow(post: snap.data.posts[i]),
        );
      },
    );
  }
}
