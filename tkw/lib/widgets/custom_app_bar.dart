import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TabBar? bottom;

  const CustomAppBar({super.key, required this.title, this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      bottom: bottom,
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}

