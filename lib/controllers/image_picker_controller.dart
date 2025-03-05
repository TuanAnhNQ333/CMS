
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {

  /// Declarations
  XFile? image;
  final ImagePicker picker = ImagePicker();

  /// To reset the stored image
  void resetImage() {
    image = null;
    update();
  }

  /// To pick an image from the gallery
  Future getImage(ImageSource media) async {
    try {
      var img = await picker.pickImage(source: media);
      if (img != null) {
        image = img;
        update();
      }
    } catch (e) {
      print("Error picking image: $e");
      update();
      // Handle the error as needed
    }
    update();
  }


}