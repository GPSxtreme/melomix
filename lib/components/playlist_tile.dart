import 'package:flutter/material.dart';
import 'package:proto_music_player/screens/playlist_view_screen.dart';

class PlaylistTile extends StatefulWidget {
  const PlaylistTile({Key? key, required this.artUrl, required this.playlistId}) : super(key: key);
  final String artUrl;
  final String playlistId;
  @override
  State<PlaylistTile> createState() => _PlaylistTileState();
}

class _PlaylistTileState extends State<PlaylistTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        const PlaylistViewScreen();
      },
      child: Image.network(widget.artUrl),
    );
  }
}
