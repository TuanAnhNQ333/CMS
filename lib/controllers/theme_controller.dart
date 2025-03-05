import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {

  var themeMode = ThemeMode.system.obs;

  void changeThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    update();
  }

}