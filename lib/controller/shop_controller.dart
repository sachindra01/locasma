import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ShopController extends GetxController{
  List items = [];
  RxBool isLoading = false.obs;
  //list of bool value in index for checkbox
  List<bool>? isChecked; 

    Future<void> readJson() async {
      try{
        isLoading(true);
        final String response = await rootBundle.loadString('assets/data/shop.json');
        final data = await json.decode(response);
        items = data["categoryItems"];
        update();
      }
      finally{
        isLoading(false);
      }
    }
}