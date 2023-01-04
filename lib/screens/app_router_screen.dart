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
//audio player global variable
late AudioPlayer mainAudioPlayer;

class AppRouter extends StatefulWidget {
  static String id = "app_router";
  static ConcatenatingAudioSource queue = ConcatenatingAudioSource(children: [],useLazyPreparation: true);
  static List audioQueueSongData = [];
  const AppRouter({Key? key}) : super(key: key);
  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  HtmlUnescape htmlDecode = HtmlUnescape();
  String currentScreen = "Home";
  final List<String> screenKeys = [HomeScreen.id, MyPlaylistsScreen.id, SearchPageScreen.id,SettingsScreen.id,DownloadsScreen.id];
  final PersistentTabController controller = PersistentTabController(initialIndex: 0);
  List<Widget> buildScreens() {
    return [
      const HomeScreen(),
      const MyPlaylistsScreen(),
      const SearchPageScreen(),
      const SettingsScreen(),
      const DownloadsScreen()
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
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.download_rounded),
        title: ("Downloads"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }


  @override
  void initState() {
    super.initState();
    mainAudioPlayer = AudioPlayer();
  }
  @override
  void dispose() {
    super.dispose();
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
      navBarStyle: NavBarStyle.style9 // Choose the nav bar style with this property.(bangers :[1,9,19])
    );
  }

}

