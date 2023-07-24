import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RankingController extends GetxController{
  List rankList = [];
  RxBool isLoading = false.obs;

    Future<void> readJson() async {
      try{
        isLoading(true);
        final String response = await rootBundle.loadString('assets/data/shop.json');
        final data = await json.decode(response);
        rankList = data["categoryItems"];
        update();
      }
      finally{
        isLoading(false);
      }
    }
}