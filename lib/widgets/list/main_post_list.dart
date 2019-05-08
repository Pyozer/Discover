import 'package:discover/models/fetch_data.dart';
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
  final _fetch = FetchData<PostsResponse>();
  final _controller = ScrollController();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    if (!mounted || _fetch.isLoading) return;
    setState(() => _fetch.isLoading = true);

    try {
      final prefs = PreferencesProvider.of(context);
      _fetch.data = await Api().getPostByLocation(
        PostsLocationPayload(
          latitude: prefs.getUserPos().latitude,
          longitude: prefs.getUserPos().longitude,
          distance: 200000,
          tags: [],
        ),
        prefs.getUser()?.token,
      );
    } catch (e) {
      _fetch.error = e;
    }
    if (!mounted) return;
    setState(() => _fetch.isLoading = false);
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
    if (_fetch.hasError) {
      return Center(child: Text(_fetch.error.toString()));
    }
    if (!_fetch.hasData && _fetch.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_fetch.data.posts?.isEmpty ?? true) {
      return Center(child: Text("Empty"));
    }

    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: _fetchPosts,
      child: ListView.builder(
        controller: _controller,
        itemCount: _fetch.data.posts.length,
        itemBuilder: (context, i) => PostRow(post: _fetch.data.posts[i]),
      ),
    );
  }
}
