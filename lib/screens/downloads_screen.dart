import 'package:flutter/material.dart';

import '../services/helper_functions.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);
  static String id = "downloads_screen";
  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Stack(
        children: [
          //body
          HelperFunctions.collapsedPlayer()
        ],
      ),
    );
  }
}
