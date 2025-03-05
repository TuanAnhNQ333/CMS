import 'package:club_app/controllers/network_controller.dart';
import 'package:club_app/controllers/theme_controller.dart';
import 'package:club_app/controllers/unread_post_controller.dart';
import 'package:get/get.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ThemeController>(ThemeController());
    Get.put<UnreadPostController>(UnreadPostController());
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}