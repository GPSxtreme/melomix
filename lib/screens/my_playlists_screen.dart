import 'package:flutter/material.dart';

import '../services/helper_functions.dart';

class MyPlaylistsScreen extends StatefulWidget {
  const MyPlaylistsScreen({Key? key}) : super(key: key);
  static String id = "my_playlists_screen";
  @override
  State<MyPlaylistsScreen> createState() => _MyPlaylistsScreenState();
}

class _MyPlaylistsScreenState extends State<MyPlaylistsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //body
          HelperFunctions.collapsedPlayer()
        ],
      ),
    );
  }
}
