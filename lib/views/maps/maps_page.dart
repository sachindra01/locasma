import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locasma/common/styles.dart';
import 'package:locasma/controller/map_controller.dart';
import 'package:locasma/helpers/map_helper.dart';
import 'package:locasma/helpers/map_marker.dart';
import 'package:locasma/widgets/custom_alert_dialogbox.dart';
import 'package:locasma/widgets/custom_button.dart';
import 'package:locasma/widgets/map_shop_details_tile.dart';
import 'package:locasma/widgets/maps_shop_list_tile.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _con = Get.put(MapController());

  //map controller
  final Completer<GoogleMapController> _mapController = Completer();
  
  //Panel Body Controller
  var panelBody = "shopList";

  //Drop down initial value for initial panel header
  var dropDownRank = "rank".tr;
  var dropDownPurchasedDate = "purchaseDate".tr;
  var dropDownViews = "noOfViews".tr;

  //Flag button to control Route list & detail page navigation though a single button
  bool navRoutePages = false;

  //Stores Details of a Shop and puts it inside a tile
  Widget? shopDetailsTileWithValue;

  //Toast
  late FToast fToast;

  //For purchase route list page to store onTap items
  List selectedItems = [];

  //inital location
  late LatLng _initialPosition;

  //markers for google map
  Set<Marker> markers = {};

  //added markers
  Map<String, dynamic> addedMarkers = {};

  //To toogle the sort heigth in the purchase route details page
  bool isPanelHeight = false;
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  var persistentContentHeight = Get.height *0.318;

    /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = {};

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker>? _clusterManager;

  final Color _clusterColor = Colors.blue;

  final Color _clusterTextColor = Colors.blue;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 8;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;
  var pageLoading = true.obs;

  /// Example marker coordinates
  final List<LatLng> _markerLocations = [];

  //stores marker Icons
  final List<BitmapDescriptor> markerIcons = [];

  @override
  void initState() {
    for (var i = 0; i < _con.markersList.length; i++) {
      _markerLocations.add(
        LatLng(double.parse(_con.markersList[i]["lat"].toString()),
            double.parse(_con.markersList[i]["lon"].toString())),
      );
    }
    _getCurrentLocation();
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }


  initializeData() async {
    await _getCurrentLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
          init: MapController(),
          builder: (_) {
            return Obx(
              () => _con.isLoading.value == true || pageLoading.value
                  ? const Center(child: CircularProgressIndicator(),)
                  : _con.shopList.isEmpty
                      ? const Center(child: Text("No Data Found!"),)
                      : panelBody == "purchaseRouteList"
                          ? purchaseRouteListBody()
                          : panelBody=="selectedMarkerList"
                          ?selectedMarkerList()
                          : Stack(
                              children: [
                                ExpandableBottomSheet(
                                  key: key,
                                  enableToggle: false,
                                  persistentContentHeight: panelBody == "shopDetails" || panelBody == "purchaseRouteDetails"
                                  ?persistentContentHeight
                                  :0.0,
                                  background: Stack(
                                    children: [
                                      Opacity(
                                        opacity: _isMapLoading ? 0 : 1,
                                        child: GoogleMap(
                                          compassEnabled: false,
                                          mapToolbarEnabled: true,
                                          zoomGesturesEnabled: true,
                                          myLocationButtonEnabled: true,
                                          myLocationEnabled: true,
                                          zoomControlsEnabled: false,
                                          initialCameraPosition: CameraPosition(
                                            target: _initialPosition,
                                            zoom: _currentZoom,
                                          ),
                                          markers: _markers,
                                          onMapCreated: (controller) =>
                                              _onMapCreated(controller),
                                          onCameraMove: (position) =>
                                              _updateMarkers(position.zoom),
                                        ),
                                      ),

                                      // Map loading indicator
                                      Opacity(
                                        opacity: _isMapLoading ? 1 : 0,
                                        child: const Center(child: CircularProgressIndicator()),
                                      ),
                                      // Map markers loading indicator
                                      if (_areMarkersLoading)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Card(
                                              elevation: 2,
                                              color: Colors.grey.withOpacity(0.9),
                                              child: const Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Text(
                                                  'Loading',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    //list of added markers button
                                      panelBody == "shopList"
                                          ? Stack(
                                              children: [
                                                Padding(
                                                  padding:const EdgeInsets.only(left: 10.0,top: 45.0),
                                                  child: SizedBox(
                                                    height: 60.0,
                                                    width: 60.0,
                                                    child: FloatingActionButton(
                                                      elevation: 3.5,
                                                      backgroundColor: white,
                                                      heroTag:"selectedItemsListBtn",
                                                      onPressed:(){
                                                        setState(() {
                                                          panelBody = "selectedMarkerList";
                                                        });
                                                      },
                                                      child: const Icon(
                                                        Icons.view_list_rounded,
                                                        color: darkBlue,
                                                        size: 40,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:const EdgeInsets.only(left: 54.0,top: 45.0),
                                                  child: ClipRRect(borderRadius:BorderRadius.circular(100),
                                                    child: Container(
                                                      height: 20.0,
                                                      width: 20.0,
                                                      alignment:Alignment.center,
                                                      color: pink,
                                                      child: FittedBox(
                                                        child: Padding(padding: const EdgeInsets.all(4.0),
                                                          child: Text(_con.selectedLocations.length.toString(), style:white12Height,),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Padding(
                                              //This button is to navigate back to the shoplist from shop details page
                                              padding: const EdgeInsets.only( left: 10.0, top: 45.0),
                                              child: SizedBox(
                                                height: 48.0,
                                                width: 48.0,
                                                child: FloatingActionButton(
                                                  elevation: 3.5,
                                                  backgroundColor: white,
                                                  heroTag: "goBack",
                                                  onPressed: () {
                                                    setState(() {
                                                      panelBody = "shopList";
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.arrow_back_ios_new_rounded,
                                                    color: darkBlue,
                                                    size: 28,
                                                  ),
                                                ),
                                              ),
                                            ),

                                      //This button apperars only in purchase Route details page
                                      panelBody == "purchaseRouteDetails"
                                          ? Padding(
                                              padding: const EdgeInsets.only( top: 46.0, right: 10.0),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: SizedBox(
                                                  height: 60.0,
                                                  width: 60.0,
                                                  child: FloatingActionButton(
                                                    elevation: 3.5,
                                                    backgroundColor: white,
                                                    heroTag: "purchaseListRouteBtn",
                                                    onPressed: () {
                                                      setState(() {
                                                        panelBody ="purchaseRouteList";
                                                      });
                                                    },
                                                    child: const Icon(
                                                      FontAwesomeIcons.directions,
                                                      color: darkBlue,
                                                      size: 28.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  persistentHeader:
                                      panelBody == "purchaseRouteDetails"
                                          ? purchaseRouteListHeader()
                                          : initialHeader(),
                                  expandableContent: panelBody == "shopList"
                                      ? shopListBody()
                                      : panelBody == "shopDetails"
                                          ? shopDetailsBody()
                                          : panelBody == "purchaseRouteList"
                                              ? purchaseRouteListBody()
                                              : panelBody =="purchaseRouteDetails"
                                                  ? purchaseRouteDetailsBody()
                                                  : const SizedBox(),
                                ),
                                
                                //Makes the screen black with opacity 40%
                                navRoutePages == true
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            navRoutePages = false;
                                          });
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          width: double.infinity,
                                          color: const Color.fromARGB(122, 0, 0, 0),
                                        ),
                                      )
                                    : const SizedBox(),

                                    //This button has two choices one to navigate to purchase route list & other to   purchase route detail
                                panelBody == "shopList"
                                    ? Positioned(
                                        right: 10.0,
                                        bottom: 95.0,
                                        child: SizedBox(
                                          height: 60.0,
                                          width: 60.0,
                                          child: FloatingActionButton(
                                            elevation: 3.5,
                                            backgroundColor: white,
                                            heroTag: "selectRoutePageBtn",
                                            onPressed: () {
                                              setState(() {
                                                navRoutePages = !navRoutePages;
                                              });
                                            },
                                            child: const Icon(
                                              Icons.directions,
                                              color: pink,
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),

                                // Buttons that appers on click of upper button
                                // PurchasedRouteDetails Page
                                navRoutePages == true
                                    ? Positioned(
                                        right: 10.0,
                                        bottom: 95.0 +MediaQuery.of(context).size.height * 0.095,
                                        child: CustomButton(
                                          btnColor: white,
                                          elevation: 6.0,
                                          height: 37.0,
                                          width: 163.0,
                                          label: FittedBox(
                                            child: Text("toRouteDetails".tr, style: pink14bold,),
                                          ),
                                          onPress: () {
                                            setState(() {
                                              navRoutePages = false;
                                              panelBody ="purchaseRouteDetails";
                                            });
                                          },
                                        ),
                                      )
                                    : const SizedBox(),

                                // PurchasedRouteList Page
                                navRoutePages == true
                                    ? Positioned(
                                        right: 96.0,
                                        bottom: 95.0 +MediaQuery.of(context).size.height * 0.014,
                                        child: CustomButton(
                                          btnColor: white,
                                          elevation: 6.0,
                                          height: 37.0,
                                          width: 163.0,
                                          label: FittedBox(
                                            child: Text("toRouteList".tr, style: pink14bold,
                                            ),
                                          ),
                                          onPress: () {
                                            setState(() {
                                              navRoutePages = false;
                                              panelBody = "purchaseRouteList";
                                            });
                                          },
                                        ),
                                      )
                                    : const SizedBox(),

                                //This edit button appears on shopDetails page
                                panelBody == "shopDetails"
                                ?Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                  padding: const EdgeInsets.only(bottom: 23.0, right: 10.0),
                                  child: CustomButton(
                                  btnColor: darkBlue,
                                  height: 60.0,
                                  width: 165.0,
                                  elevation: 4.0,
                                  onPress: () {},
                                  label: Text(
                                  "toEdit".tr,
                                  style: white24,
                               ),
                             ),
                            ),
                          )
                          :const SizedBox(),                          
                        ],
                      ),
            );
          },
        ),
    );
  }

  //Initial header
  Widget initialHeader() {
    return GestureDetector(
      onTap: (){
        setState(() {
          isPanelHeight = !isPanelHeight;
          if(isPanelHeight == false){
            key.currentState!.expand();
          }else{
            key.currentState!.contract();
          }
          
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 2.0),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.0815,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical( top: Radius.circular(16.0),),
          color: white,
          boxShadow: [
            BoxShadow(
              color: seperetorColor,
              offset: Offset(0, 2),
              blurRadius: 0.2,
              spreadRadius: 0.6,
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 6.0,
            ),
            //Drag Indicator
            Center(
              child: Container(
                width: 32,
                height: 3,
                decoration: const BoxDecoration(
                  color: Color(0xff68859D),
                  borderRadius: BorderRadius.all(
                    Radius.circular(2),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 7.0,
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 28,
                        width: 28,
                        margin: const EdgeInsets.only(left: 14.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          border: const Border(
                            top: BorderSide(width: 1, color: lightGrey),
                            left: BorderSide(width: 1, color: lightGrey),
                            right: BorderSide(width: 1, color: lightGrey),
                            bottom: BorderSide(width: 1, color: lightGrey),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            CustomAlertDialogueBox().customDialogue(
                              context,
                              const Text("Header"),
                              const Text("this is the body"),
                            );
                          },
                          child: const Icon(
                            Icons.sort_rounded,
                            size: 22,
                            color: darkGrey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Container(
                        height: 28,
                        padding: const EdgeInsets.only(left: 12.0, right: 3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: const Border(
                            top: BorderSide(width: 1, color: lightGrey),
                            left: BorderSide(width: 1, color: lightGrey),
                            right: BorderSide(width: 1, color: lightGrey),
                            bottom: BorderSide(width: 1, color: lightGrey),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            DropdownButton<String>(
                              value: dropDownRank,
                              underline: const SizedBox(),
                              isDense: true,
                              icon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: darkBlue,
                              ),
                              style: darkBlue16w400,
                              onChanged: (String? newValue) {
                                setState(
                                  () {
                                    dropDownRank = newValue!;
                                  },
                                );
                              },
                              items: <String>[
                                'rank'.tr,
                                'Rate',
                                'Classic',
                                'Casual'
                              ].map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Container(
                        height: 28,
                        padding: const EdgeInsets.only(left: 12.0, right: 3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: const Border(
                            top: BorderSide(width: 1, color: lightGrey),
                            left: BorderSide(width: 1, color: lightGrey),
                            right: BorderSide(width: 1, color: lightGrey),
                            bottom: BorderSide(width: 1, color: lightGrey),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            DropdownButton<String>(
                              value: dropDownPurchasedDate,
                              isDense: true,
                              underline: const SizedBox(),
                              icon: const Icon(Icons.arrow_drop_down_rounded,color: darkBlue,
                              ),
                              style: darkBlue16w400,
                              onChanged: (String? newValue) {
                                setState(
                                  () {
                                    dropDownPurchasedDate = newValue!;
                                  },
                                );
                              },
                              items: <String>[
                                'purchaseDate'.tr,
                                'Rate',
                                'Classic',
                                'Casual'
                              ].map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Container(
                        height: 28,
                        padding: const EdgeInsets.only(left: 12.0, right: 3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: const Border(
                            top: BorderSide(width: 1, color: lightGrey),
                            left: BorderSide(width: 1, color: lightGrey),
                            right: BorderSide(width: 1, color: lightGrey),
                            bottom: BorderSide(width: 1, color: lightGrey),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            DropdownButton<String>(
                              value: dropDownViews,
                              underline: const SizedBox(),
                              isDense: true,
                              icon: const Icon(Icons.arrow_drop_down_rounded,color: darkBlue,),
                              style: darkBlue16w400,
                              onChanged: (String? newValue) {
                                setState(
                                  () {
                                    dropDownViews = newValue!;
                                  },
                                );
                              },
                              items: <String>[
                                'noOfViews'.tr,
                                'Rate',
                                'Classic',
                                'Casual'
                              ].map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget purchaseRouteListHeader() {
    return GestureDetector(
      onTap: (){
        setState(() {
          isPanelHeight = !isPanelHeight;
          if(isPanelHeight == false){
            key.currentState!.expand();
          }else{
            key.currentState!.contract();
          }
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.077,
        margin: const EdgeInsets.only(bottom: 2.0),
        decoration: const BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: seperetorColor,
              offset: Offset(0, 2),
              blurRadius: 0.2,
              spreadRadius: 0.6,
            ),
          ],
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 6.0,
            ),
            //Drag Indicator
            GestureDetector(
              onTap: () {},
              child: Center(
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: const BoxDecoration(
                    color: Color(0xff68859D),
                    borderRadius: BorderRadius.all(
                      Radius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.edit_note_outlined,
                    size: 22,
                    color: grey,
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  //This header title comes from Api
                  Text(
                    _con.purchaseRouteList.isNotEmpty
                        ? _con.purchaseRouteList[0]["purchaseRouteDate"]
                        : "unnamedRoute".tr,
                    //style: black20,
                    style: black20Height,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget shopListBody() {
    return Container(
      color: white,
      constraints: BoxConstraints(maxHeight: Get.height * 0.7687),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: _con.shopList.length,
            itemBuilder: (context, index) {
              var data = _con.shopList[index];
              return MapShopListTile(
                name: data['name'],
                image: data['image'],
                location: data['location'],
                rank: data['rank'],
                distance: data['distance'],
                onSeeMoreBtnTap: () {
                  //This Navigates to details page
                  setState(
                    () {
                      panelBody = "shopDetails";
                      shopDetailsTileWithValue = MapShopDetailTile(
                        name: data['name'],
                        image: data['image'],
                        location: data['location'],
                        rank: data['rank'],
                        distance: data['distance'],
                        businessHour: data['businessHour'],
                        memo: data['memo'],
                        views: data['views'],
                        purchasedDate: data['purchasedDate'],
                        onAddBtnTap: () {
                          fToast.showToast(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12.0,
                                  ),
                                  child: Container(
                                    width: 500.0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF1F9FF),
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: const Border(
                                        top:BorderSide(width: 1, color: darkBlue),
                                        left: BorderSide(width: 1, color: darkBlue),
                                        right:BorderSide(width: 1, color: darkBlue),
                                        bottom: BorderSide(width: 1, color: darkBlue),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "addedToPurchaseRoute".tr,
                                      style: darkBlue16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    fToast.removeCustomToast();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        height: 20.0,
                                        width: 20.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffF1F9FF),
                                          borderRadius:BorderRadius.circular(100.0),
                                          border: const Border(
                                            top: BorderSide(width: 1, color: darkBlue),
                                            left: BorderSide( width: 1, color: darkBlue),
                                            right: BorderSide(width: 1, color: darkBlue),
                                            bottom: BorderSide(width: 1, color: darkBlue),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: const FittedBox(
                                          child: Text("x",
                                            style: TextStyle(
                                                color: darkBlue,
                                                fontSize: 14.0,
                                                height: 0.9),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            toastDuration: const Duration(seconds: 2),
                            positionedToastBuilder: (context, child) {
                              return Positioned(
                                child: child,
                                top: 40.0,
                                left: 16.0,
                                right: 16.0,
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
                onAddBtnTap: () {
                  fToast.showToast(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 12.0,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffF1F9FF),
                              borderRadius: BorderRadius.circular(4.0),
                              border: const Border(
                                top: BorderSide(width: 1, color: darkBlue),
                                left: BorderSide(width: 1, color: darkBlue),
                                right: BorderSide(width: 1, color: darkBlue),
                                bottom: BorderSide(width: 1, color: darkBlue),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text("addedToPurchaseRoute".tr,style: darkBlue16,),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            fToast.removeCustomToast();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 20.0,
                                width: 20.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xffF1F9FF),
                                  borderRadius: BorderRadius.circular(100.0),
                                  border: const Border(
                                    top: BorderSide(width: 1, color: darkBlue),
                                    left: BorderSide(width: 1, color: darkBlue),
                                    right: BorderSide(width: 1, color: darkBlue),
                                    bottom: BorderSide(width: 1, color: darkBlue),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const FittedBox(
                                  child: Text("x",
                                    style: TextStyle(
                                        color: darkBlue,
                                        fontSize: 14.0,
                                        height: 0.9),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    toastDuration: const Duration(seconds: 2),
                    positionedToastBuilder: (context, child) {
                      return Positioned(
                        child: child,
                        top: 40.0,
                        left: 16.0,
                        right: 16.0,
                      );
                    },
                  );
                },
              );
            },
          ),
          SizedBox(height:Get.height*0.75),
        ],
      ),
    );
  }

  Widget shopDetailsBody() {
    return Container(
      color: white,
      constraints: BoxConstraints(maxHeight: Get.height * 0.7687),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          shopDetailsTileWithValue!,
        ],
      ),
    );
  }

  // Panel with Route Header & PurchaseRouteList Page
  Widget purchaseRouteListBody() {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              //Header
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 3.0),
                padding: const EdgeInsets.only(
                    top: 26.0, left: 16.0, right: 16.0, bottom: 16.0),
                decoration: const BoxDecoration(
                  color: white,
                  boxShadow: [
                    BoxShadow(
                      color: seperetorColor,
                      offset: Offset(0, 0),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          panelBody = "shopList";
                        });
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: darkBlue,
                        size: 28.0,
                      ),
                    ),
                    const SizedBox(
                      width: 28.0,
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.zero,
                          child: Icon(
                            Icons.directions,
                            color: darkBlue,
                            size: 38.0,
                          ),
                        ),
                        const SizedBox(
                          width: 6.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: FittedBox(
                            child: Text(
                              "purchasingRouteList".tr,
                              style: black20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Body
              Expanded(
                child: ListView(
                  children: [
                    //Custom Tile
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _con.purchaseRouteList.length,
                      itemBuilder: ((context, index) {
                        var routeList = _con.purchaseRouteList[index];
                        return Slidable(
                          key: const ValueKey("delete"),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                key: const ValueKey("deleteOnSlide"),
                                onPressed: (context) {
                                  setState(() {
                                    _con.purchaseRouteList.removeAt(index);
                                  });
                                },
                                backgroundColor: const Color(0xFFF4726A),
                                foregroundColor: Colors.white,
                                label: 'delete'.tr,
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                var item = routeList["routes"];
                                if (selectedItems.contains(routeList["routes"])) {
                                  selectedItems.remove(item);
                                } else {
                                  selectedItems.add(item);
                                }
                              });
                            },
                            child: Container(
                              height: 50.0,
                              width: double.infinity,
                              color: selectedItems.contains(routeList["routes"])
                                  ? const Color(0xffFCF4F5)
                                  : listTileColor,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Text(
                                    routeList["routes"],
                                    style: selectedItems.contains(routeList["routes"])
                                        ? pink16
                                        : darkGrey16,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 20,
                                    color: selectedItems.contains(routeList["routes"])
                                        ? pink
                                        : darkGrey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 20.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: CustomButton(
                btnColor: pink,
                height: 54.0,
                elevation: 4.0,
                onPress: () {},
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "createANewRoute".tr,
                    style: white20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Panel with Route Header & PurchaseRouteDetails Page
  Widget purchaseRouteDetailsBody() {
    return _con.purchaseRouteList.isNotEmpty
        ? Container(
            constraints: BoxConstraints(maxHeight: Get.height * 0.7687),
            color: white,
            child: ReorderableListView(
              padding: EdgeInsets.only(bottom: Get.height *0.555),
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex--;
                setState(() {
                  final item = _con.purchaseRouteList.removeAt(oldIndex);
                  _con.purchaseRouteList.insert(newIndex, item);
                });
              },
              children: List.generate(
                _con.purchaseRouteList.length,
                (index) {
                  return Slidable(
                    key: ValueKey(_con.purchaseRouteList[index]),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            setState(() {
                              _con.purchaseRouteList.removeAt(index);
                            });
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          label: 'delete'.tr,
                        ),
                      ],
                    ),
                    child: ListTile(
                      key: ValueKey(_con.purchaseRouteList[index]['name']),
                      title: Text(_con.purchaseRouteList[index]['name'],
                          style: darkGrey16),
                      trailing: const Icon(
                        Icons.menu,
                        color: darkGrey,
                        size: 20.0,
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        //If the Api has no Data
        : Container(
            constraints: const BoxConstraints(maxHeight: 300),
            color: Colors.white,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 26.0,
                ),
                Text(
                  "noStoresHasBeenAddedYet".tr,
                  style: grey16,
                ),
                const SizedBox(height: 18.0,),
                CustomButton(
                  btnColor: pink,
                  elevation: 0.0,
                  height: 56.0,
                  width: 202.0,
                  onPress: () {},
                  label: Text(
                    "addStore".tr,
                    style: white24,
                  ),
                ),
              ],
            ),
          );
  }

  Widget selectedMarkerList(){
     return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              //Header
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 3.0),
                padding: const EdgeInsets.only(
                    top: 26.0, left: 16.0, right: 16.0, bottom: 16.0),
                decoration: const BoxDecoration(
                  color: white,
                  boxShadow: [
                    BoxShadow(
                      color: seperetorColor,
                      offset: Offset(0, 0),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          panelBody = "shopList";
                        });
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: darkBlue,
                        size: 28.0,
                      ),
                    ),
                    const SizedBox(
                      width: 28.0,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: FittedBox(
                        child: Text(
                          "Selected Locations",
                          style: black20,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          _con.selectedLocations.clear();
                          _initMarkers();
                          });
                      },
                      child: const Text("Clear All"),
                      ),
                  ],
                ),
              ),
              //Body
              Expanded(
                child: ListView(
                  children: [
                    //Custom Tile
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _con.selectedLocations.length,
                      itemBuilder: ((context, index) {
                        var routeList =_con.selectedLocations;
                        return Slidable(
                          key: const ValueKey("delete"),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                key: const ValueKey("deleteOnSlide"),
                                onPressed: (context) {
                                  setState(() {
                                    routeList.removeAt(index);
                                    _initMarkers();
                                  });
                                },
                                backgroundColor: const Color(0xFFF4726A),
                                foregroundColor: Colors.white,
                                label: 'delete'.tr,
                              ),
                            ],
                          ),
                          child: Container(
                            height: 50.0,
                            width: double.infinity,
                            padding:const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: CachedNetworkImage(imageUrl: routeList[index]["markerIcon"], height: 30, width: 30,)),
                                const SizedBox(width: 20.0,),
                                Text( routeList[index]["snippet"],
                                style: darkGrey16,
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 20.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: CustomButton(
                btnColor: pink,
                height: 54.0,
                elevation: 4.0,
                onPress: () {
                  setState(() {
                    addedMarkers.clear();
                    _con.joinStops.clear();
                    _con.joinStopsNoLast.clear();
                     for (int i = 0; i < _con.selectedLocations.length; i++) {
                     addedMarkers.addAll({
                      "lat":_con.selectedLocations[i]["lat"],
                      "lon":_con.selectedLocations[i]["lon"],
                    });
                    _con.joinStops.add(addedMarkers.values.join(","));
                    _con.joinStopsNoLast.add(addedMarkers.values.join(","));
                    }
                  });
                 
               _con.selectedLocations.isEmpty
               ?//Notifies added on press
                   fToast.showToast(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12.0,
                                  ),
                                  child: Container(
                                    width: 500.0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF1F9FF),
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: const Border(
                                        top:BorderSide(width: 1, color: darkBlue),
                                        left: BorderSide(width: 1, color: darkBlue),
                                        right:BorderSide(width: 1, color: darkBlue),
                                        bottom: BorderSide(width: 1, color: darkBlue),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Selected Locations are empty",
                                      style: darkBlue16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    fToast.removeCustomToast();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        height: 20.0,
                                        width: 20.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffF1F9FF),
                                          borderRadius:BorderRadius.circular(100.0),
                                          border: const Border(
                                            top: BorderSide(width: 1, color: darkBlue),
                                            left: BorderSide( width: 1, color: darkBlue),
                                            right: BorderSide(width: 1, color: darkBlue),
                                            bottom: BorderSide(width: 1, color: darkBlue),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: const FittedBox(
                                          child: Text("x",
                                            style: TextStyle(
                                                color: darkBlue,
                                                fontSize: 14.0,
                                                height: 0.9),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            toastDuration: const Duration(seconds: 2),
                            positionedToastBuilder: (context, child) {
                              return Positioned(
                                child: child,
                                top: 40.0,
                                left: 16.0,
                                right: 16.0,
                              );
                            },
                          )
                    :_con.selectedLocations.length ==1 
                    ? //Notifies added on press
                    fToast.showToast(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12.0,
                                  ),
                                  child: Container(
                                    width: 500.0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF1F9FF),
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: const Border(
                                        top:BorderSide(width: 1, color: darkBlue),
                                        left: BorderSide(width: 1, color: darkBlue),
                                        right:BorderSide(width: 1, color: darkBlue),
                                        bottom: BorderSide(width: 1, color: darkBlue),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Select At least 2 points",
                                      style: darkBlue16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    fToast.removeCustomToast();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        height: 20.0,
                                        width: 20.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffF1F9FF),
                                          borderRadius:BorderRadius.circular(100.0),
                                          border: const Border(
                                            top: BorderSide(width: 1, color: darkBlue),
                                            left: BorderSide( width: 1, color: darkBlue),
                                            right: BorderSide(width: 1, color: darkBlue),
                                            bottom: BorderSide(width: 1, color: darkBlue),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: const FittedBox(
                                          child: Text("x",
                                            style: TextStyle(
                                                color: darkBlue,
                                                fontSize: 14.0,
                                                height: 0.9),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            toastDuration: const Duration(seconds: 2),
                            positionedToastBuilder: (context, child) {
                              return Positioned(
                                child: child,
                                top: 40.0,
                                left: 16.0,
                                right: 16.0,
                              );
                            },
                          )
                        :_con.launchGoogleMaps();},
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text("Directions",style: white20,),
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }

    //locats current location
  _getCurrentLocation() async {
    var position = await GeolocatorPlatform.instance
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        _initialPosition = LatLng(position.latitude, position.longitude);
        pageLoading(false);
  }


  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
    setState(() {
      _isMapLoading = false;
    });
    _initMarkers();
  }
  
  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    final List<MapMarker> markers = [];
    for (int i = 0; i < _con.markersList.length; i++) {
      markerIcons.add( await MapHelper.getMarkerImageFromUrl(_con.markersList[i]["markerIcon"]));
        markers.add(
        MapMarker(
          id: _markerLocations[i].toString(),
          position: _markerLocations[i],
          icon: markerIcons[i],
          infoWindow: InfoWindow(
            title: checkIfLocationIsAdded({
                    "lat": _con.markersList[i]["lat"],
                    "lon": _con.markersList[i]["lon"],
                    "snippet":_con.markersList[i]["snippet"],
                    "markerIcon":_con.markersList[i]["markerIcon"]
                  })["snippet"] == _con.markersList[i]["snippet"]
                  ?"- Remove"
                  :"+ Add",
            snippet: _con.markersList[i]["snippet"],
            onTap: (){
              setState(() {
                _con.selectedLocations.isNotEmpty
                // ignore: avoid_function_literals_in_foreach_calls
                ?_con.selectedLocations.forEach((element) {
                  if(checkIfLocationIsAdded({
                    "lat": _con.markersList[i]["lat"],
                    "lon": _con.markersList[i]["lon"],
                    "snippet":_con.markersList[i]["snippet"],
                    "markerIcon":_con.markersList[i]["markerIcon"]
                  })["snippet"] == _con.markersList[i]["snippet"]){
                    setState(() {
                       _initMarkers();
                    });
                    removeLocation(checkIfLocationIsAdded({
                    "lat": _con.markersList[i]["lat"],
                    "lon": _con.markersList[i]["lon"],
                    "snippet":_con.markersList[i]["snippet"],
                    "markerIcon":_con.markersList[i]["markerIcon"]
                  }));
                    setState(() {});
                    } else{
                      addLocation(i);
                      _initMarkers();
                      }
                })
                :[addLocation(i), _initMarkers()];
              });
            },
          ),

        ),
      );
    }
    _clusterManager = (await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    ));

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double? updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      InfoWindow(
        title: "See More",
        snippet: "Zoom in to see more",
        onTap: (){}
      ),
      markerIcons,
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
        ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }

  checkIfLocationIsAdded(data){
  var location = {};
  // ignore: avoid_function_literals_in_foreach_calls
  _con.selectedLocations.forEach((element) {
    if(element['snippet'] == data['snippet']){
      setState(() {
        location = element;
      });
    }
  });
   return location;
  }

  addLocation(var index){
    setState(() {
      _con.selectedLocations.add({
        "lat": _con.markersList[index]["lat"],
        "lon": _con.markersList[index]["lon"],
        "snippet":_con.markersList[index]["snippet"],
        "markerIcon":_con.markersList[index]["markerIcon"]
        });
    });

    //Notifies added on press
          fToast.showToast(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only( top: 12.0,),
                  child: Container(
                    width: 500.0,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    margin: const EdgeInsets.symmetric(horizontal: 6.0,),
                    decoration: BoxDecoration(
                      color: const Color(0xffF1F9FF),
                      borderRadius: BorderRadius.circular(4.0),
                      border: const Border(
                        top:BorderSide(width: 1, color: darkBlue),
                        left: BorderSide(width: 1, color: darkBlue),
                        right:BorderSide(width: 1, color: darkBlue),
                        bottom: BorderSide(width: 1, color: darkBlue),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Added (${_con.markersList[index]["snippet"]}) to list",
                      style: darkBlue16,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    fToast.removeCustomToast();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 20.0,
                        width: 20.0,
                        decoration: BoxDecoration(
                          color: const Color(0xffF1F9FF),
                          borderRadius:BorderRadius.circular(100.0),
                          border: const Border(
                            top: BorderSide(width: 1, color: darkBlue),
                            left: BorderSide( width: 1, color: darkBlue),
                            right: BorderSide(width: 1, color: darkBlue),
                            bottom: BorderSide(width: 1, color: darkBlue),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const FittedBox(
                          child: Text("x",
                            style: TextStyle(
                                color: darkBlue,
                                fontSize: 14.0,
                                height: 0.9),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            toastDuration: const Duration(seconds: 2),
            positionedToastBuilder: (context, child) {
              return Positioned(
                child: child,
                top: 40.0,
                left: 16.0,
                right: 16.0,
              );
            },
          );
  }

  removeLocation(var index){
    setState(() {
      _con.selectedLocations.remove(index);
    });

    //Notifies added on press
          fToast.showToast(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only( top: 12.0,),
                  child: Container(
                    width: 500.0,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    margin: const EdgeInsets.symmetric(horizontal: 6.0,),
                    decoration: BoxDecoration(
                      color: const Color(0xffF1F9FF),
                      borderRadius: BorderRadius.circular(4.0),
                      border: const Border(
                        top:BorderSide(width: 1, color: darkBlue),
                        left: BorderSide(width: 1, color: darkBlue),
                        right:BorderSide(width: 1, color: darkBlue),
                        bottom: BorderSide(width: 1, color: darkBlue),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Removed (${index["snippet"]}) from list",
                      style: darkBlue16,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    fToast.removeCustomToast();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 20.0,
                        width: 20.0,
                        decoration: BoxDecoration(
                          color: const Color(0xffF1F9FF),
                          borderRadius:BorderRadius.circular(100.0),
                          border: const Border(
                            top: BorderSide(width: 1, color: darkBlue),
                            left: BorderSide( width: 1, color: darkBlue),
                            right: BorderSide(width: 1, color: darkBlue),
                            bottom: BorderSide(width: 1, color: darkBlue),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const FittedBox(
                          child: Text("x",
                            style: TextStyle(
                                color: darkBlue,
                                fontSize: 14.0,
                                height: 0.9),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            toastDuration: const Duration(seconds: 2),
            positionedToastBuilder: (context, child) {
              return Positioned(
                child: child,
                top: 40.0,
                left: 16.0,
                right: 16.0,
              );
            },
          );
  }
}
