import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/home_screen_module.dart';
import '../services/helper_functions.dart';
import 'package:flutter/scheduler.dart' show timeDilation;


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String id = "home_screen";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    timeDilation = 1.1; // Will slow down animations by a factor of 1.1
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 13),
                child: Hero( tag:'logo',child: Text("Melomix",style: GoogleFonts.pacifico(fontSize: 27,color: Colors.white,),textAlign: TextAlign.start,)),
              ),
              const HomeScreenModule(),
            ],
          ),
          //body
          HelperFunctions.collapsedPlayer()
        ],
      ),
    );
  }
}
