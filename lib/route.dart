import 'package:get/get_navigation/src/routes/get_route.dart';

import 'screens/app_router_screen.dart';
import 'screens/artist_view_screen.dart';
import 'screens/common_view_screen.dart';
import 'screens/downloads_screen.dart';
import 'screens/full_player_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lyrics_screen.dart';
import 'screens/my_playlists_screen.dart';
import 'screens/search_page_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';

class Routes {
  static String splashScreen = "/splash_screen";
  static String appRouterScreen = "/app_router_screen";
  static String artistViewScreen = "/artist_view_screen";
  static String commonViewScreen = "/common_view_screen";
  static String downloadsScreen = "/downloads_screen";
  static String fullPlayerScreen = "/full_player_screen";
  static String homeScreen = "/home_screen";
  static String lyricsScreen = "lyrics_screen";
  static String myPlaylistsScreen = "/my_playlists_screen";
  static String settingsScreen = "/settings_screen";
  static String searchPageScreen = "/search_page_screen";
  static String offlineFolderViewScreen = "/offline_folder_view_screen";

  static List<GetPage> getPages = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: appRouterScreen, page: () => const AppRouter()),
    // GetPage(name: artistViewScreen, page: () => const ArtistViewScreen()),
    // GetPage(name: commonViewScreen, page: () => const CommonViewScreen()),
    GetPage(name: downloadsScreen, page: () => const DownloadsScreen()),
    // GetPage(name: fullPlayerScreen, page: () => const FullPlayerScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    // GetPage(name: lyricsScreen, page: () => const LyricsScreen()),
    GetPage(name: myPlaylistsScreen, page: () => const MyPlaylistsScreen()),
    GetPage(name: settingsScreen, page: () => const SettingsScreen()),
    GetPage(name: searchPageScreen, page: () => const SearchPageScreen()),
  ];
}
