import 'dart:async';

import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locasma/common/styles.dart';
import 'package:locasma/controller/map_controller.dart';
import 'package:locasma/helpers/map_helper.dart';
import 'package:locasma/helpers/map_marker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final MapController _con = Get.put(MapController());
  //added markers
  Map<String, dynamic> addedMarkers = {};
  //Toast
  late FToast fToast;

  final Completer<GoogleMapController> _mapController = Completer();
  //to find current position
  // ignore: unused_field
  late Position currentPosition;

  final MapController mapsController= Get.put(MapController());
  late GoogleMapController mapController;

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = {};

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker>? _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 5.0;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  /// Example marker coordinates
  final List<LatLng> _markerLocations = [];

  final List<BitmapDescriptor> markerIcons = [];

   //locats current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        currentPosition = position;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 5.0,
            ),
          ),
        );
      });
    }).catchError((e) {});
  }

  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.
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
    

    for (int i = 0; i < mapsController.markersList.length; i++) {
     markerIcons.add( await MapHelper.getMarkerImageFromUrl(mapsController.markersList[i]["markerIcon"]));
     _updateMarkers();
      markers.add(
        MapMarker(
          id: _markerLocations[i].toString(),
          position: _markerLocations[i],
          icon: markerIcons[i],
          infoWindow: InfoWindow(
            title: "+ ADD",
            snippet: mapsController.markersList[i]["snippet"],
            onTap: (){
              setState(() {
                //add markers to list
                addedMarkers.addAll({
                  "lat": _con.markersList[i]["lat"],
                  "lon": _con.markersList[i]["lon"],
                });
                _con.joinStops.add(addedMarkers.values.join(","));
                _con.joinStopsNoLast.add(addedMarkers.values.join(","));
              });

              //Notifies added on press
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
                                      "Successfully Added Location",
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
          )
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
  Future<void> _updateMarkers([double? updatedZoom] ) async {
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

  @override
  void initState() {
    setState(() {
      for (int i = 0; i < mapsController.markersList.length; i++){
        _markerLocations.add(LatLng(mapsController.markersList[i]["lat"], mapsController.markersList[i]["lon"]),);
      }
    });
    fToast = FToast();
    fToast.init(context);
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Markers and Clusters Example'),
      ),
      body: Stack(
        children: <Widget>[
          // Google Map widget
          Opacity(
            opacity: _isMapLoading ? 0 : 1,
            child: GoogleMap(
              mapToolbarEnabled: true,
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: CameraPosition(
                target: const LatLng(27, 85),
                zoom: _currentZoom,
              ),
              markers: _markers,
              onMapCreated: (controller) => _onMapCreated(controller),
              onCameraMove: (position) => _updateMarkers(position.zoom),
            ),
          ),

          // Map loading indicator
          Opacity(
            opacity: _isMapLoading ? 1 : 0,
            child: const Center(child:  CircularProgressIndicator()),
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
        ],
      ),
    );
  }
}
