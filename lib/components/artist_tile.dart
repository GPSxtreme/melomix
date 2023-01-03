import 'package:flutter/material.dart';

class ArtistTile extends StatefulWidget {
  const ArtistTile({Key? key, required this.artUrl, required this.artistId}) : super(key: key);
  final String artUrl;
  final String artistId;
  @override
  State<ArtistTile> createState() => _ArtistTileState();
}

class _ArtistTileState extends State<ArtistTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(widget.artUrl),
        backgroundColor: Colors.white,
      ),
    );
  }
}
