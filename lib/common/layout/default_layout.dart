import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroudnColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floactingActionButton;

  const DefaultLayout(
      {super.key,
      required this.child,
      this.backgroudnColor,
      this.title,
      this.bottomNavigationBar,
      this.floactingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroudnColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floactingActionButton,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title!,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}
