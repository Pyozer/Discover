import 'package:discover/widgets/post/post_row.dart';
import 'package:flutter/material.dart';

class MainPostList extends StatefulWidget {
  MainPostList({Key key}) : super(key: key);
  
  @override
  MainPostListState createState() => MainPostListState();
}

class MainPostListState extends State<MainPostList> {
  final ScrollController _controller = ScrollController();

  Future _fetchData() async {
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> goToTop() {
    return _controller.animateTo(0,
        curve: Curves.easeIn, duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _fetchData,
      child: ListView.builder(
        controller: _controller,
        itemBuilder: (_, __) => PostRow(),
      ),
    );
  }
}
