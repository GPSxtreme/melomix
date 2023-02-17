import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/home_screen_module.dart';
import '../services/helper_functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String id = "home_screen";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 13),
                child: Row(
                  children: [
                    Text("Melomix",style: GoogleFonts.pacifico(fontSize: 27,color: Colors.white,),textAlign: TextAlign.start,),
                    const Spacer(),
                    const CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person_rounded,color: Colors.blue,size: 30,),
                    )
                  ],
                ),
              ),
              const HomeScreenModule(languages: ["english"],),
            ],
          ),
          //body
          HelperFunctions.collapsedPlayer()
        ],
      ),
    );
  }
}
