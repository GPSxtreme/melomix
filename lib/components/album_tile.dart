import 'package:flutter/material.dart';

class AlbumTile extends StatefulWidget {
  const AlbumTile({Key? key, required this.artUrl, required this.albumId}) : super(key: key);
  final String artUrl;
  final String albumId;
  @override
  State<AlbumTile> createState() => _AlbumTileState();
}

class _AlbumTileState extends State<AlbumTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Image.network(widget.artUrl,height: 100,width: 100,),
    );
  }
}
