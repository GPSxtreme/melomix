import 'package:flutter/material.dart';
import 'package:proto_music_player/screens/proto_home.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: ProtoHome.id,
      routes: {
        ProtoHome.id:(context) => const ProtoHome(),
      },
    );
  }
}



