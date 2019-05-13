import 'package:after_layout/after_layout.dart';
import 'package:discover/models/fetch_data.dart';
import 'package:discover/models/posts/posts_response.dart';
import 'package:discover/models/posts/request/posts_location_payload.dart';
import 'package:discover/models/posts/sort_mode.dart';
import 'package:discover/models/tags/tag.dart';
import 'package:discover/utils/api/api.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:discover/widgets/post/post_row.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MainPostList extends StatefulWidget {
  final Position userPos;
  final SortMode sortMode;
  final double distance;
  final List<Tag> tags;

  MainPostList({
    Key key,
    @required this.userPos,
    @required this.sortMode,
    @required this.distance,
    @required this.tags,
  }) : super(key: key);

  @override
  MainPostListState createState() => MainPostListState();
}

class MainPostListState extends State<MainPostList> with AfterLayoutMixin {
  final _fetch = FetchData<PostsResponse>(isLoading: true);
  final _controller = ScrollController();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void afterFirstLayout(BuildContext coontext) {
    _fetchPosts();
  }

  @override
  void didUpdateWidget(MainPostList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isSamePos = widget.userPos.toString() == oldWidget.userPos.toString();
    final isSameSort = widget.sortMode == oldWidget.sortMode;
    final isSameDistance = widget.distance == oldWidget.distance;
    final isSameTags = widget.tags == oldWidget.tags;
    if (!isSamePos || !isSameSort || !isSameDistance || !isSameTags)
      _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    if (!mounted) return;
    _refreshKey.currentState?.show();
    setState(() => _fetch.isLoading = true);

    try {
      final prefs = PreferencesProvider.of(context);
      _fetch.data = await Api().getPostByLocation(
        PostsLocationPayload(
          sortMode: widget.sortMode,
          latitude: widget.userPos?.latitude,
          longitude: widget.userPos?.longitude,
          distance: widget.distance.toInt(),
          tags: widget.tags,
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
    if (_fetch.data?.posts?.isEmpty ?? true) {
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
