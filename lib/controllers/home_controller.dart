import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/helper_functions.dart';
import '../components/online_song_tile.dart';
import '../components/top_album_tile.dart';
import '../components/top_carousel_card.dart';
import '../components/results_common_tile.dart';

class HomeController extends GetxController {
  var isLoaded = false.obs;
  var trendingSongs = <OnlineSongResultTile>[].obs;
  var trendingAlbums = <TopAlbumTile>[].obs;
  var displayCards = <TopCarouselCard>[].obs;
  var charts = <CommonResultTile>[].obs;
  var playlists = <CommonResultTile>[].obs;
  var albums = <CommonResultTile>[].obs;
  int totalCardsCount = 5;
  var currentCardIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    isLoaded(false); // Equivalent to setState(() => isLoaded = false);
    // Clear all lists
    trendingSongs.clear();
    trendingAlbums.clear();
    displayCards.clear();
    charts.clear();
    playlists.clear();
    albums.clear();
    // Your fetch logic here (simplified for brevity)
    // After fetching data, update the observables
    isLoaded(true); // Equivalent to setState(() => isLoaded = true);
  }
}
