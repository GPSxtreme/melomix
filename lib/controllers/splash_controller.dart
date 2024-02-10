import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proto_music_player/route.dart';
import '../services/app_settings.dart';

class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    await fetchRoutine();
    super.onInit();
  }

  Future<void> fetchRoutine() async {
    //request permissions.
    await Permission.storage.request();
    await Permission.accessMediaLocation.request();
    await Permission.manageExternalStorage.request();
    await Permission.accessMediaLocation.request();
    await Permission.mediaLibrary.request();
    //fetch app settings.
    await AppSettings.fetchAppSettings();
    Get.offAndToNamed(Routes.appRouterScreen);
  }
}
