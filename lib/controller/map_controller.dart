import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapController extends GetxController {
  List shopList = [];
  List purchaseRouteList = [];
  List markersList = [];
  List selectedLocations = [];
  List joinStops = []; // list to join markers
  List joinStopsNoLast = []; // list to join markers without last markers
  List addedMarkersAll = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    fetchShopListData();
    fetchPurchaseRouteListData();
    readJson();
    super.onInit();
  }


  fetchShopListData() async {
    try {
      isLoading(true);
      String response =
          await rootBundle.loadString('assets/data/shop_list.json');
      final data = json.decode(response);
      shopList = data['shopLists'];
      update();
    } finally {
      isLoading(false);
    }
  }

  fetchPurchaseRouteListData() async {
    try {
      isLoading(true);
      String response =
          await rootBundle.loadString('assets/data/purchase_routes.json');
      final data = json.decode(response);
      purchaseRouteList = data['purchaseRouteLists'];
      update();
    } finally {
      isLoading(false);
    }
  }

  Future<void> readJson() async {
    try{
      isLoading(true);
      markersList.clear();
      final String response = await rootBundle.loadString('assets/data/shop.json');
      final data = await json.decode(response);
      markersList = data["categoryItems"];
      update();
    }
    finally{
      isLoading(false);
    }
  }

  //method to launch maps
  Future<void> launchGoogleMaps() async {
    joinStopsNoLast.removeLast();
    String googleUrl = "google.navigation:q=${joinStops.last}&waypoints=${joinStopsNoLast.join("|")}&travelmode=driving&dir_action=navigate";
    launchUrlString(googleUrl);
  }

}