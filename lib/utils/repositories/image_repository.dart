import 'package:club_app/utils/network_services/image_service.dart';
import 'package:image_picker/image_picker.dart';
import '/controllers/network_controller.dart';
import 'package:get/get.dart';

class ImageRepository{

  static bool isInternetConnectionAvailable() {
    // Check internet connection
    final networkController = Get.find<NetworkController>();
    return networkController.isOnline.value;
  }

  Future<String> uploadImage(XFile image) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    // Upload image
    return ImageService.uploadImage(image);
  }


}