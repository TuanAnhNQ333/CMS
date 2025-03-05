
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomSnackBar{

  CustomSnackBar({required String message, required Color color});

  static show(BuildContext context, {required String message, required Color color}) {
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(customSnackBar(message: message, color: color));
  }

  static SnackBar customSnackBar({required String message, required Color color}) {
    return SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white),),
      elevation: 10.0,
      duration: const Duration(seconds: 3),
      showCloseIcon: true,
      closeIconColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: color,
    );
  }
}

class CustomGetSnackBar{
  static show({required String message, required Color color}) {
    Get.snackbar(
      'No Internet',
      message,
      mainButton: TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Icon(Icons.close, color: Colors.white, size: 20,)
      ),
      animationDuration: const Duration(milliseconds: 300),
      barBlur: 10,
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}

