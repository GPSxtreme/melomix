import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ShowLyrics extends StatefulWidget {
  const ShowLyrics({Key? key, required this.lyrics,}) : super(key: key);
  final Map lyrics;
  @override
  State<ShowLyrics> createState() => _ShowLyricsState();
}

class _ShowLyricsState extends State<ShowLyrics> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      builder:(_,controller) => Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: HexColor("#111111"),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28)
              )
          ),
          child: ListView(
            controller: controller,
            children: [
              Text(widget.lyrics["data"]["lyrics"] ?? "Not Available",
                style: const TextStyle(
                  wordSpacing: 2.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20,),
              Text(widget.lyrics["data"]["copyright"].toString().replaceAll("<br>", '\n') ?? "",style: const TextStyle( wordSpacing: 1.2,color: Colors.blue,fontWeight: FontWeight.w600,fontSize: 15),textAlign: TextAlign.center,)
            ],
          )
      ),
    );
  }
}
