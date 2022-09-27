import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/assets/constants.dart';

/// Widget for displaying loading animation and doing background work at the same time.
class NotAllowedPage extends StatefulWidget {
  const NotAllowedPage({Key? key}) : super(key: key);
  @override
  _NotAllowedPageState createState() => _NotAllowedPageState();
}

class _NotAllowedPageState extends State<NotAllowedPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
        color: Color(COLOR_LIGHT_BLEU),
        child : Center(
            child: Text("ACCESS NOT ALLOWED", textAlign: TextAlign.center)
        )
    );
  }
}