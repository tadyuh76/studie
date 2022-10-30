import 'package:flutter/material.dart';

class HideScrollbar extends StatelessWidget {
  final Widget child;
  const HideScrollbar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: child,
    );
  }
}
