import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:just_audio/just_audio.dart';
import 'package:proto_music_player/screens/downloads_screen.dart';
import 'package:proto_music_player/screens/home_screen.dart';
import 'package:proto_music_player/screens/my_playlists_screen.dart';
import 'package:proto_music_player/screens/search_page_screen.dart';
import 'package:proto_music_player/screens/settings_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
//audio player global variable
late AudioPlayer mainAudioPlayer;

class AppRouter extends StatefulWidget {
  static String id = "app_router";
  static bool isOnline = false;
  static late bool isOverWifi;
  static ConcatenatingAudioSource queue = ConcatenatingAudioSource(children: [],useLazyPreparation: true);
  const AppRouter({Key? key}) : super(key: key);
  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  HtmlUnescape htmlDecode = HtmlUnescape();
  late StreamSubscription<ConnectivityResult> connectionState;
  String currentScreen = "Home";
  final List<String> screenKeys = [HomeScreen.id, MyPlaylistsScreen.id, SearchPageScreen.id,SettingsScreen.id,DownloadsScreen.id];
  final PersistentTabController controller = PersistentTabController(initialIndex: 0);
  List<Widget> buildScreens() {
    return [
      const HomeScreen(),
      const MyPlaylistsScreen(),
      const SearchPageScreen(),
      const SettingsScreen(),
      // const DownloadsScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_rounded),
        title: ("Home"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.my_library_music_rounded),
        title: ("My music"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.search_rounded),
        title: ("Search"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings_rounded),
        title: ("Settings"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.white,
      ),
      // PersistentBottomNavBarItem(
      //   icon: const Icon(Icons.download_rounded),
      //   title: ("Downloads"),
      //   activeColorPrimary: Colors.blue,
      //   inactiveColorPrimary: Colors.white,
      // ),
    ];
  }

  requestPermissions()async{
    await Permission.storage.request();
    await Permission.accessMediaLocation.request();
    await Permission.manageExternalStorage.request();
    await Permission.accessMediaLocation.request();
    await Permission.mediaLibrary.request();
  }
  updateConnectionStatus(ConnectivityResult result){
    if(result == ConnectivityResult.wifi){
      AppRouter.isOnline = true;
      AppRouter.isOverWifi = true;
    }else if(result == ConnectivityResult.mobile || result == ConnectivityResult.vpn){
      AppRouter.isOnline = true;
      AppRouter.isOverWifi = false;
    }else if(result == ConnectivityResult.none){
      AppRouter.isOnline = false;
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
    connectionState = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      updateConnectionStatus(result);
      if(kDebugMode){
        print(result);
      }
    });
    mainAudioPlayer = AudioPlayer();
  }
  @override
  void dispose() {
    super.dispose();
    connectionState.cancel();
    mainAudioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: HexColor("111111"), // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true,
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.easeInCubic,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style13 // Choose the nav bar style with this property.(bangers :[1,9,13,14])
    );
  }

}

