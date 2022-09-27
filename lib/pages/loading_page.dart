import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/assets/constants.dart';
import 'package:loading_animations/loading_animations.dart';

///
/// Widget for displaying loading animation and doing background work at the same time.
///
class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child : Center(
        child: LoadingBouncingGrid.square(
          backgroundColor: LOADING_ICON_COLOR,
          size: LOADING_ICON_SIZE,
        )
    )
    );
  }

}