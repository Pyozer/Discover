import 'dart:math';

import 'package:flutter/material.dart';

const kExpandedHeight = 225.0;
const kAnimationDuration = Duration(milliseconds: 100);

class CollapsingAppbar extends StatefulWidget {
  final String title;
  final Widget image;
  final Widget floatingActionButton;
  final List<Widget> actions;
  final List<Widget> children;

  CollapsingAppbar({
    @required this.title,
    this.floatingActionButton,
    @required this.children,
    this.actions = const [],
    this.image,
  });

  @override
  CollapsingAppbarState createState() => CollapsingAppbarState();
}

class CollapsingAppbarState extends State<CollapsingAppbar>
    with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController _controller;
  ScrollController _scrollController;
  bool _isTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final newIsTitle = _scrollController.position.pixels > 180.0;
      if (newIsTitle != _isTitle || newIsTitle == false)
        setState(() => _isTitle = newIsTitle);
    });

    _controller = AnimationController(
      vsync: this,
      duration: kAnimationDuration,
    );
    animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollView = CustomScrollView(
      controller: _scrollController,
      cacheExtent: 4000,
      slivers: [
        SliverAppBar(
          expandedHeight: kExpandedHeight,
          pinned: true,
          title: Text(_isTitle ? widget.title : ""),
          actions: widget.actions,
          flexibleSpace: FlexibleSpaceBar(background: widget.image),
        ),
        SliverList(
          delegate: SliverChildListDelegate(widget.children),
        ),
      ],
    );

    if (widget.floatingActionButton == null) return scrollView;

    return Stack(
      children: [scrollView, _buildFab()],
    );
  }

  Widget _buildFab() {
    // Image size - ~FAB size/2
    double top = kExpandedHeight - 28;
    double scale = 1.0;

    if (_scrollController.hasClients) {
      top -= max(_scrollController.offset, 0);

      final position = _scrollController.position;

      final maxS = position.maxScrollExtent;
      final minS = maxS - (kExpandedHeight - kToolbarHeight);

      scale = (position.extentAfter - minS) / (position.maxScrollExtent - minS);
    }
    _controller.animateTo(scale > 0.8 ? 1.0 : 0.0);

    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: top,
            right: 16.0,
            child: ScaleTransition(
              scale: animation,
              child: widget.floatingActionButton,
            ),
          ),
        ],
      ),
    );
  }
}
