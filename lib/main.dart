import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proto_music_player/screens/app_router_screen.dart';
void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //change according to app themes
    // systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.black.withOpacity(0.3), // status bar color
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.id,
      routes: {
        AppRouter.id:(context) => const AppRouter(),
      },
    );
  }
}



