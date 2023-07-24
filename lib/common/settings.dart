import 'package:flutter/material.dart';
import 'package:get/get.dart';

changeLocale() {
  var locale = Get.locale;
  if(locale == null){
    Get.updateLocale(const Locale('en'));
  } else {
    locale.languageCode == 'en'
      ? Get.updateLocale(const Locale('ja'))
      : Get.updateLocale(const Locale('en'));
  }
}