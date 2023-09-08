import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  RxBool isDarkmode = false.obs;
  void toggleTheme() {
    isDarkmode.value = !isDarkmode.value;
  }
}
