import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:proto_music_player/screens/app_router_screen.dart';
import 'package:proto_music_player/services/app_settings.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //change according to app themes
    // systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.black.withOpacity(0.3), // status bar color
  ));
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await AppSettings.fetchAppSettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< Updated upstream
      initialRoute: AppRouter.id,
=======
      theme: ThemeData.dark(useMaterial3: false),
      initialRoute: SplashScreen.id,
>>>>>>> Stashed changes
      routes: {
        AppRouter.id:(context) => const AppRouter(),
      },
    );
  }
}



