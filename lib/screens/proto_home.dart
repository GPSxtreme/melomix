import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../components/playerButtons.dart';

class ProtoHome extends StatefulWidget {
  static String id = "proto_home";
  const ProtoHome({Key? key}) : super(key: key);
  @override
  State<ProtoHome> createState() => _ProtoHomeState();
}

class _ProtoHomeState extends State<ProtoHome> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Set a sequence of audio sources that will be played by the audio player.
    _audioPlayer
        .setAudioSource(ConcatenatingAudioSource(children: [
      AudioSource.uri(Uri.parse(
          "https://aac.saavncdn.com/459/2e521dc340a013605dffa4e0e33f77b2_160.mp4")),
      AudioSource.uri(Uri.parse(
          "https://aac.saavncdn.com/837/79119e88ab03e090243ae47d84e8a4e4_320.mp4")),
      AudioSource.uri(Uri.parse(
          "https://aac.saavncdn.com/341/51a08c34557d39c2da36f117a2c57a22_320.mp4")),
    ]))
        .catchError((error) {
      // catch load errors: 404, invalid url ...
      if (kDebugMode) {
        print("An error occured $error");
      }
    });
  }
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("proto_music_player"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(child:Container()),
            PlayerButtons(_audioPlayer),
            const SizedBox(height: 20,)
          ],
        )
      ),
    );
  }

}

