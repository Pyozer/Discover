import 'package:discover/widgets/post_row.dart';
import 'package:flutter/material.dart';

class MainPostList extends StatefulWidget {
  @override
  _MainPostListState createState() => _MainPostListState();
}

class _MainPostListState extends State<MainPostList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (_, __) => PostRow(),
    );
  }
}
