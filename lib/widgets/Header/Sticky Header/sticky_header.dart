import 'package:flutter/material.dart';

class StickySliver extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  StickySliver({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return SizedBox(
      height: height,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_) => true;
}
