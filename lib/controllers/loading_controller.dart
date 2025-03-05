import 'package:get/get.dart';

class LoadingController extends GetxController {
  var isLoading = false.obs;

  void toggleLoading() {
    isLoading.value = !isLoading.value;
  }
}