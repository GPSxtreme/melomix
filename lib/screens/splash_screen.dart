import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proto_music_player/services/helper_functions.dart';
import '../services/app_settings.dart';
import 'app_router_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static String id = "splash_screen";
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  fetchRoutine()async{
    //request permissions.
    await Permission.storage.request();
    await Permission.accessMediaLocation.request();
    await Permission.manageExternalStorage.request();
    await Permission.accessMediaLocation.request();
    await Permission.mediaLibrary.request();
    //fetch app settings.
    await AppSettings.fetchAppSettings();
    // ignore: use_build_context_synchronously
    Future.delayed(const Duration(seconds: 2),() => Navigator.popAndPushNamed(context, AppRouter.id));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRoutine();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset.topRight,
                end: FractionalOffset.bottomLeft,
                colors: [
                  HexColor("00000"),
                  HexColor("222222"),
                ],
                stops: const [
                  0.0,
                  0.5
                ])
        ),
        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional.center,
              child: Hero(
                tag: "logo",
                child: Text("Melomix",style: GoogleFonts.pacifico(
                    color: Colors.white,fontSize: 40,
                  shadows: const <Shadow>[
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      blurRadius: 8.0,
                      color: Color.fromARGB(125, 0, 0, 255),
                    ),
                  ],
                ),
                ),
              ),
            ),
            Column(
              children: [
                const Spacer(),
                const SpinKitSpinningLines(color: Colors.white,size: 60,),
                const SizedBox(height: 50,),
                HelperFunctions.makerSign(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
