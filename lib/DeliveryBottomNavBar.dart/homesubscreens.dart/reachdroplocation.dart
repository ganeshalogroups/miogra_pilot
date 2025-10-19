// ignore_for_file: depend_on_referenced_packages, unused_field

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/orderupdatecontroller.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/tripscontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/map_tracking/map_tracking_screen.dart';
import 'package:miogra_service/Shimmer/reachdroplocationshimmer.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class ReachDropLocationBottomSheet extends StatefulWidget {
  final String id;
  final String orderId;
  final bool roundTrip;

  const ReachDropLocationBottomSheet(
      {super.key,
      required this.id,
      required this.orderId,
      required this.roundTrip});

  @override
  State<ReachDropLocationBottomSheet> createState() =>
      _ReachDropLocationBottomSheetState();
}

class _ReachDropLocationBottomSheetState
    extends State<ReachDropLocationBottomSheet> {
  final NewTripsController newTripsController = Get.put(NewTripsController());
  OrderUpdateController orderUpdateController = OrderUpdateController();
  final Location _locationService = Location();
  LatLng? _restLocation;
  final Completer<GoogleMapController> _controller = Completer();

  GoogleMapController? mapController;
  final Set<Polyline> _polylines = {};
  static LatLng _customerLocation =
      LatLng(8.3187095, 77.2058101); // Example restaurant location

  BitmapDescriptor? _restLocationIcon;
  BitmapDescriptor? _delLocationIcon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setCustomMarkers();

      _getCurrentLocation();
      // _restLocation;
      _customerLocation;
      newTripsController.getTripsbyId(widget.id);
    });
  }

  Future<BitmapDescriptor> _resizeMarkerImage(
      String assetPath, int width, int height) async {
    ByteData data = await rootBundle.load(assetPath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? resizedData =
        await fi.image.toByteData(format: ui.ImageByteFormat.png);

    if (resizedData != null) {
      return BitmapDescriptor.fromBytes(resizedData.buffer.asUint8List());
    } else {
      throw 'Error resizing marker image';
    }
  }

  Future<void> _setCustomMarkers() async {
    try {
      _restLocationIcon = await _resizeMarkerImage(
          'assets/images/Courier.png', 175, 175); // Resize to 48x48 pixels
      _delLocationIcon = await _resizeMarkerImage(
          'assets/images/Destination.png', 175, 175); // Resize to 48x48 pixels
    } catch (e) {
      // print('$error');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      var locationData = await _locationService.getLocation();
      LatLng newLocation =
          LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);

      setState(() {
        _restLocation = newLocation;
      });
      _updatePolylines();

      // Perform Firestore update and polyline retrieval in parallel
      await Future.wait([
        updateData(
          latitude: newLocation.latitude,
          longitude: newLocation.longitude,
          rotation: locationData.heading ?? 0.0,
        ),
        _getDirections(_restLocation!, _customerLocation),
      ]);
    } catch (e) {
      // print('$error');
    }
  }

  Future<void> _launchGoogleMapsForDirections(
      double destinationLat, double destinationLng) async {
    final googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch Google Maps.';
    }
  }

  Future<void> updateData({latitude, longitude, rotation}) async {
    CollectionReference locations =
        FirebaseFirestore.instance.collection('locationData');

    // Update the document with the given z
    await locations
        .doc('6qWVFBkHYFRjt2EJO1ak')
        .update({
          'rotation': rotation,
          'latitude': latitude,
          'longitude': longitude,
        })
        .then((_) {})
        .catchError((error) {});
  }

// Fetch directions from Google Directions API
  Future<void> _getDirections(LatLng origin, LatLng destination) async {
    final String apiKey = "AIzaSyCJsmwlhksyLs9IGRpkbM90c-RqtIBHqtQ";
    // "AIzaSyCxjzqu6TtZl--tNK_tK6IhAdrTo2AwYc0";
    final String url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&mode=driving&key=$apiKey';

    try {
      var response = await Dio().get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        List<dynamic> routes = data['routes'];

        if (routes.isNotEmpty) {
          String encodedPolyline = routes[0]['overview_polyline']['points'];
          _setPolyline(encodedPolyline);
        }
      }
    } catch (e) {
      // print('$e');
    }
  }

// Decode the polyline and set it on the map
  void _setPolyline(String encodedPolyline) {
    List<LatLng> polylinePoints = _decodePolyline(encodedPolyline);

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: polylinePoints,
          color: Color.fromARGB(255, 248, 90, 5),
          width: 4,
        ),
      );
    });
    _moveCameraToBounds(polylinePoints);
  }

// Decode encoded polyline
  List<LatLng> _decodePolyline(String polylineString) {
    List<LatLng> polylineCoordinates = [];
    int index = 0;
    int len = polylineString.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = polylineString.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = polylineString.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng latLng = LatLng(lat / 1E5, lng / 1E5);
      polylineCoordinates.add(latLng);
    }

    return polylineCoordinates;
  }

  Future<String> _getPolylineString(LatLng origin, LatLng destination) async {
    final String apiKey = "AIzaSyCJsmwlhksyLs9IGRpkbM90c-RqtIBHqtQ";
   // "AIzaSyCxjzqu6TtZl--tNK_tK6IhAdrTo2AwYc0";
    final String url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&mode=driving&key=$apiKey';

    try {
      var response = await Dio().get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        List<dynamic> routes = data['routes'];
        if (routes.isNotEmpty) {
          return routes[0]['overview_polyline']['points'];
        }
      }
      throw 'No routes found';
    } catch (e) {
      rethrow;
    }
  }

  void _updatePolylines() async {
    if (_restLocation != null) {
      final encodedPolyline =
          await _getPolylineString(_restLocation!, _customerLocation);
      List<LatLng> polylinePoints = _decodePolyline(encodedPolyline);

      setState(() {
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: polylinePoints,
            color: Color.fromARGB(255, 248, 90, 5),
            width: 4,
          ),
        );
      });
      _updateCameraPosition();
    }
  }

  void _updateCameraPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(
      _calculateBounds(
          _polylines.expand((polyline) => polyline.points).toList()),
      50,
    ));
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double minLat =
        points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
    double maxLat =
        points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
    double minLng =
        points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
    double maxLng =
        points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);
    return LatLngBounds(
        southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng));
  }

  void _moveCameraToBounds(List<LatLng> polylinePoints) {
    if (polylinePoints.isNotEmpty) {
      LatLngBounds bounds;
      if (polylinePoints.length == 1) {
        bounds = LatLngBounds(
            southwest: polylinePoints.first, northeast: polylinePoints.first);
      } else {
        bounds = _calculateBounds(polylinePoints);
      }
      mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {}
  }

  // Future<bool> _onWillPop() async {
  //   // Prevent the back navigation by returning false
  //   return false;
  // }
  void showFloatingOverlay(BuildContext context) async {
    if (!await FlutterOverlayWindow.isPermissionGranted()) {
      await FlutterOverlayWindow.requestPermission();
    }

    if (await FlutterOverlayWindow.isPermissionGranted()) {
      if (await FlutterOverlayWindow.isActive()) return;
      await FlutterOverlayWindow.showOverlay(
        alignment: OverlayAlignment.centerRight,
        enableDrag: true,
        overlayTitle: "Miogra",
        overlayContent: 'Overlay Enabled',
        flag: OverlayFlag.defaultFlag,
        visibility: NotificationVisibility.visibilityPublic,
        positionGravity: PositionGravity.auto,
        height: (MediaQuery.of(context).size.height * 0.18).toInt(),
        width: WindowSize.matchParent,
        startPosition: const OverlayPosition(0, -259),
      );
      // await FlutterOverlayWindow.showOverlay(
      //   alignment: OverlayAlignment.centerRight,
      //   flag: OverlayFlag.defaultFlag,
      //   enableDrag: true,
      // );
    }
    // final isGranted = await FlutterOverlayWindow.isPermissionGranted();
    // if (!isGranted) {
    //   // You may prompt the user to allow overlay permission here
    //   return;
    // }

    // final isActive = await FlutterOverlayWindow.isActive();
    // if (isActive) return;

    // final overlayHeight = (MediaQuery.of(context).size.height * 0.18).toInt();

    // // Show overlay
    // await FlutterOverlayWindow.showOverlay(
    //   alignment: OverlayAlignment.centerRight,
    //   enableDrag: true,
    //   overlayTitle: "FastX",
    //   overlayContent: 'Overlay Enabled',
    //   flag: OverlayFlag.defaultFlag,
    //   visibility: NotificationVisibility.visibilityPublic,
    //   positionGravity: PositionGravity.auto,
    //   height: overlayHeight,
    //   width: WindowSize.matchParent,
    //   startPosition: const OverlayPosition(0, -259),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // automaticallyImplyLeading: false,
          title: CustomText(
            text: 'Reach Drop Location',
            style: CustomTextStyle.screenTitle,
          ),
        ),
        body: Obx(() {
          if (newTripsController.isdataLoading.value) {
            return ReachDroplocationShimmer();
          }

          if (newTripsController.newTripsbyid.isEmpty) {
            return Center(child: Text('No data found'));
          }

          var tripData = newTripsController.newTripsbyid.first;

          var restaurantName =
              tripData['subAmdminDetails']?['name'] ?? 'Unknown';
          var restaurantAddress = tripData['subAmdminDetails']?['address']
                  ['fullAddress'] ??
              'Unknown';
          var customerContact = tripData['deliveryDetails']?[0]
                  ?['contactPersonNumber'] ??
              'Unknown';
          var triptype = tripData['orderDetails']?['deliveryType'] ?? '';
          var additionalInstructions =
              tripData['orderDetails']["additionalInstructions"];
          var paymentmethod =
              tripData['orderDetails']["paymentMethod"] == "ONLINE"
                  ? "Online Payment"
                  : "Cash on Delivery";
          var customerName =
              tripData['deliveryDetails']?[0]?['contactPerson'] ?? 'Unknown';
          var customerHousenumb =
              tripData['deliveryDetails']?[0]?['houseNo'] ?? 'Unknown';
          var customerLandmark =
              tripData['deliveryDetails']?[0]?['landMark'] ?? 'Unknown';
          var customerAddress =
              tripData['deliveryDetails']?[0]?['fullAddress'] ?? 'Unknown';

          var restImage = tripData['subAmdminDetails']?['imgUrl'] ?? 'Unknown';
          var delType =
              tripData['subAmdminDetails']?['subAdminType'] ?? 'Unknown';
          var deliveryLatitude = double.tryParse(
                  tripData['deliveryDetails']?[0]?['latitude']?.toString() ??
                      '0.0') ??
              0.0;
          var deliveryLongitude = double.tryParse(
                  tripData['deliveryDetails']?[0]?['longitude']?.toString() ??
                      '0.0') ??
              0.0;
          var pickupLatitude = double.tryParse(
                  tripData['pickupDetails']?[0]?['latitude']?.toString() ??
                      '0.0') ??
              0.0;
          var pickupLongitude = double.tryParse(
                  tripData['pickupDetails']?[0]?['longitude']?.toString() ??
                      '0.0') ??
              0.0;
          // Update _pRestaurant with the new coordinates
          _customerLocation = LatLng(deliveryLatitude, deliveryLongitude);
          //   var pickupLatitude = double.tryParse(tripData['pickupDetails']?[0]?['latitude']?.toString() ?? '0.0') ?? 0.0;
          //       var pickupLongitude = double.tryParse(tripData['pickupDetails']?[0]?['longitude']?.toString() ?? '0.0') ?? 0.0;
          // // Update _pRestaurant with the new coordinates
          // _restLocation = LatLng(pickupLatitude, pickupLongitude);

          return PopScope(
              // canPop: false,
              // onPopInvoked: (bool didPop) async {
              //   Get.back();
              //   //return;
              // },
              child: Stack(children: [
            SizedBox(
                height: MediaQuery.of(context).size.height / 1.8,
                child: MapTrackingScreen(
                  tripStatus: tripData['tripStatus'],
                  orderId: widget.orderId,
                  isAccepted: false,
                  id: widget.id,
                  delLat: widget.roundTrip == true
                      ? pickupLatitude
                      : deliveryLatitude,
                  delLong: widget.roundTrip == true
                      ? pickupLongitude
                      : deliveryLongitude,
                  restarantlocation: false,
                )),
            DraggableScrollableSheet(
              // initialChildSize: 0.35, // starting height
              // minChildSize: 0.2, // minimum height
              // maxChildSize: 0.9, // maximum height
              initialChildSize: 0.6, // Starts at 60% of screen height
              minChildSize: 0.5, // Can't be dragged below 50%
              maxChildSize: 0.95, // Can expand up to 95%
              builder: (context, scrollController) {
                return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        controller: scrollController, // important!
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  text:
                                      'Order ID: #${tripData['orderDetails']?['orderCode'] ?? ''}',
                                  style: CustomTextStyle.blueAmountText,
                                ),
                                Spacer(),
                                if (triptype == 'round')
                                  CustomText(
                                    text: 'Round Trip',
                                    style: CustomTextStyle.redSmallText,
                                  ),
                              ],
                            ),
                            CustomSizedBox(
                              height: 12,
                            ),
                            CustomText(
                                text: delType == 'restaurant'
                                    ? 'Customer Info'
                                    : 'Drop Location',
                                style: CustomTextStyle.smallGreyText),
                            CustomSizedBox(height: 12),
                            Row(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 8),
                                    SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: Image.asset(
                                          'assets/images/homeicon.png',color: 
 Color(0xFF623089)
,),
                                    ),
                                    SizedBox(width: 17),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.65,
                                      // height: MediaQuery.of(context)
                                      //         .size
                                      //         .height /
                                      //     12,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                              text: customerName ?? '',
                                              style: CustomTextStyle.smallText),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: CustomText(
                                              text:
                                                  '${customerHousenumb ?? ''}, ${customerLandmark ?? ''}, ${customerAddress ?? ''}',
                                              style:
                                                  CustomTextStyle.smallGreyText,
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          InkWell(
                                            onTap: () async {
                                              await _launchGoogleMapsForDirections(
                                                  double.parse(tripData[
                                                              'deliveryDetails']
                                                          [0]['latitude']
                                                      .toString()),
                                                  double.parse(tripData[
                                                              'deliveryDetails']
                                                          [0]['longitude']
                                                      .toString()));

                                              showFloatingOverlay(context);
                                              // if (!await FlutterOverlayWindow
                                              //       .isPermissionGranted()) {
                                              //     await FlutterOverlayWindow
                                              //         .requestPermission();

                                              //   }

                                              //   if (await FlutterOverlayWindow
                                              //       .isPermissionGranted()) {
                                              //           if (await FlutterOverlayWindow.isActive())
                                              //     return;
                                              //   await FlutterOverlayWindow.showOverlay(
                                              //       alignment: OverlayAlignment.centerRight,
                                              //     enableDrag: true,
                                              //     overlayTitle: "X-SLAYER",
                                              //     overlayContent: 'Overlay Enabled',
                                              //     flag: OverlayFlag.defaultFlag,
                                              //     visibility:
                                              //         NotificationVisibility.visibilityPublic,
                                              //     positionGravity: PositionGravity.auto,
                                              //     height:
                                              //         (MediaQuery.of(context).size.height *
                                              //                 0.18)
                                              //             .toInt(),
                                              //     width: WindowSize.matchParent,
                                              //     startPosition:
                                              //         const OverlayPosition(0, -259),
                                              //   );}
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Customcolors
                                                        .darkPurple,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "View in Map",
                                                  style: CustomTextStyle
                                                      .orangetext,
                                                ),
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 15),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final Uri url =
                                            Uri.parse('tel:$customerContact');
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                      child: SizedBox(
                                        //   color: Colors.deepOrange,
                                        height: 25,
                                        width: 25,
                                        child: Image.asset(
                                            'assets/images/orangephone.png',color:  Color(0xFF623089),),
                                      ),
                                    ),
                                    //  InkWell(
                                    //   onTap: () async {
                                    //         await _launchGoogleMapsForDirections(
                                    //         double.parse(tripData['pickupDetails']
                                    //             [0]['latitude'].toString()),
                                    //         double.parse(tripData['pickupDetails']
                                    //             [0]['longitude'].toString()));
                                    //   },
                                    //   child:Container(
                                    //   margin: EdgeInsets.all(5),
                                    //   decoration: BoxDecoration(border: Border.all(color: Customcolors.darkPurple,),borderRadius:BorderRadius.circular(10)),
                                    //     child: Center(child: Padding(
                                    //       padding: const EdgeInsets.all(8.0),
                                    //       child: Text("View in Map",style: CustomTextStyle.orangetext,),
                                    //     )),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                            CustomSizedBox(
                              height: 12,
                            ),
                            CustomText(
                                text: delType == 'restaurant'
                                    ? 'Restaurant Info'
                                    : 'Pickup Location',
                                style: CustomTextStyle.smallGreyText),
                            CustomSizedBox(height: 12),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      delType == 'restaurant'
                                          ? CustomContainer(
                                              height: 38,
                                              width: 38,
                                              child: ClipOval(
                                                  child: Image.network(
                                                "$globalImageUrlLink${restImage}",
                                                fit: BoxFit.cover,
                                              )))
                                          : Row(
                                              children: [
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                CustomContainer(
                                                    height: 17,
                                                    width: 17,
                                                    child: Image.asset(
                                                        'assets/images/homeicon.png',color:  Color(0xFF623089),)),
                                              ],
                                            ),
                                      SizedBox(width: 13),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.7,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                                text: delType == 'restaurant'
                                                    ? restaurantName
                                                    : tripData['pickupDetails']
                                                            ?[0]?['name']
                                                        .toString(),
                                                style:
                                                    CustomTextStyle.smallText),
                                            CustomText(
                                              text: delType == 'restaurant'
                                                  ? restaurantAddress
                                                  : tripData['pickupDetails']
                                                          ?[0]?['fullAddress']
                                                      .toString(),
                                              style:
                                                  CustomTextStyle.smallGreyText,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                            CustomSizedBox(
                              height: 12,
                            ),
                            paymentmethod == null || paymentmethod.isEmpty
                                ? SizedBox()
                                : Text("Payment Method:",
                                    style: CustomTextStyle.smallGreyText),
                            CustomSizedBox(height: 12),
                            Row(
                              children: [
                                SizedBox(width: 15),
                                paymentmethod == null || paymentmethod.isEmpty
                                    ? SizedBox()
                                    : Container(
                                        height: 25,
                                        width: 25,
                                        child: Image.asset(
                                            'assets/images/income.png'),
                                      ),
                                SizedBox(width: 17),
                                paymentmethod == null || paymentmethod.isEmpty
                                    ? SizedBox()
                                    : Text(paymentmethod.toString(),
                                        style: CustomTextStyle.smallGreyText),
                              ],
                            ),
                            CustomSizedBox(
                              height: 12,
                            ),
                            additionalInstructions == null ||
                                    additionalInstructions.isEmpty
                                ? SizedBox()
                                : Text("Delivery Instructions:",
                                    style: CustomTextStyle.smallGreyText),
                            CustomSizedBox(height: 12),
                            Row(
                              children: [
                                SizedBox(width: 15),
                                additionalInstructions == null ||
                                        additionalInstructions.isEmpty
                                    ? SizedBox()
                                    : Container(
                                        height: 17,
                                        width: 17,
                                        child: Image.asset(
                                          'assets/images/info.png',
                                          color: Customcolors.darkPurple,
                                        ),
                                      ),
                                SizedBox(width: 17),
                                additionalInstructions == null ||
                                        additionalInstructions.isEmpty
                                    ? SizedBox()
                                    : Text(
                                        additionalInstructions
                                            .toString()
                                            .capitalizeFirst
                                            .toString(),
                                        style: CustomTextStyle.smallGreyText),
                              ],
                            ),
                            CustomSizedBox(height: 12),
                            DottedLine(),
                            CustomSizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomButton(
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(20),
                                onPressed: () {
                                  if (widget.roundTrip == true) {
                                    orderUpdateController.updateDeliveredStatus(
                                      tripData['_id'] ?? '',
                                      DateTime.now(),
                                    );
                                  } else {
                                    orderUpdateController
                                        .updateReachedDeliveryStatus(
                                      tripData['_id'] ?? '',
                                      DateTime.now(),
                                    );
                                  }
                                },
                                child: CustomText(
                                  text: widget.roundTrip == true
                                      ? 'End Trip'
                                      : delType == 'restaurant'
                                          ? 'Reached Delivery Location'
                                          : 'Reached Drop Location',
                                  style: CustomTextStyle.buttonText,
                                ),
                              ),
                            ),
                            SizedBox(height: 10)
                          ],
                        ),
                      ),
                    ));
              },
            ),

            // Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Spacer(),
            //     Container(
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.only(
            //             topLeft: Radius.circular(25),
            //             topRight: Radius.circular(25),
            //           ),
            //         ),
            //         child: Padding(
            //           padding: const EdgeInsets.all(15.0),
            //           child: SingleChildScrollView(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Row(
            //                   children: [
            //                     CustomText(
            //                       text:
            //                           'Order ID: #${tripData['orderDetails']?['orderCode'] ?? ''}',
            //                       style: CustomTextStyle.blueAmountText,
            //                     ),
            //                     Spacer(),
            //                     if (triptype == 'round')
            //                       CustomText(
            //                         text: 'Round Trip',
            //                         style: CustomTextStyle.redSmallText,
            //                       ),
            //                   ],
            //                 ),
            //                 CustomSizedBox(
            //                   height: 12,
            //                 ),
            //                 CustomText(
            //                     text: delType == 'restaurant'
            //                         ? 'Customer Info'
            //                         : 'Drop Location',
            //                     style: CustomTextStyle.smallGreyText),
            //                 CustomSizedBox(height: 12),
            //                 Row(
            //                   children: [
            //                     Row(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         SizedBox(width: 8),
            //                         SizedBox(
            //                           height: 18,
            //                           width: 18,
            //                           child: Image.asset(
            //                               'assets/images/homeicon.png'),
            //                         ),
            //                         SizedBox(width: 17),
            //                         SizedBox(
            //                           width: MediaQuery.of(context)
            //                                   .size
            //                                   .width /
            //                               1.65,
            //                           // height: MediaQuery.of(context)
            //                           //         .size
            //                           //         .height /
            //                           //     12,
            //                           child: Column(
            //                             crossAxisAlignment:
            //                                 CrossAxisAlignment.start,
            //                             children: [
            //                               CustomText(
            //                                   text: customerName ?? '',
            //                                   style: CustomTextStyle
            //                                       .smallText),
            //                               SizedBox(
            //                               width: MediaQuery.of(context).size.width/1.8,
            //                                 child: CustomText(
            //                                   text:
            //                                       '${customerHousenumb ?? ''}, ${customerLandmark ?? ''}, ${customerAddress ?? ''}',
            //                                   style: CustomTextStyle
            //                                       .smallGreyText,
            //                                 ),
            //                               )
            //                             ],
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     // SizedBox(width: 15),
            //                     Column(
            //                       children: [
            //                         InkWell(
            //                           onTap: () async {
            //                             final Uri url =
            //                                 Uri.parse('tel:$customerContact');
            //                             if (await canLaunchUrl(url)) {
            //                               await launchUrl(url);
            //                             } else {
            //                               throw 'Could not launch $url';
            //                             }
            //                           },
            //                           child: SizedBox(
            //                             //   color: Colors.deepOrange,
            //                             height: 25,
            //                             width: 25,
            //                             child: Image.asset(
            //                                 'assets/images/orangephone.png'),
            //                           ),
            //                         ),
            //                         SizedBox(height: 15,),
            //                  InkWell(
            //                   onTap: () async {
            //                         await _launchGoogleMapsForDirections(
            //                         double.parse(tripData['pickupDetails']
            //                             [0]['latitude'].toString()),
            //                         double.parse(tripData['pickupDetails']
            //                             [0]['longitude'].toString()));
            //                   },
            //                   child:Container(
            //                   margin: EdgeInsets.all(5),
            //                   decoration: BoxDecoration(border: Border.all(color: Customcolors.darkPurple,),borderRadius:BorderRadius.circular(10)),
            //                     child: Center(child: Padding(
            //                       padding: const EdgeInsets.all(8.0),
            //                       child: Text("View in Map",style: CustomTextStyle.orangetext,),
            //                     )),
            //                   ),
            //                 ),
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //                 CustomSizedBox(
            //                   height: 12,
            //                 ),
            //                 CustomText(
            //                     text: delType == 'restaurant'
            //                         ? 'Restaurant Info'
            //                         : 'Pickup Location',
            //                     style: CustomTextStyle.smallGreyText),
            //                 CustomSizedBox(height: 12),
            //                 Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Row(
            //                         children: [
            //                           delType == 'restaurant'
            //                               ? CustomContainer(
            //                                   height: 38,
            //                                   width: 38,
            //                                   child: ClipOval(
            //                                       child: Image.network(
            //                                     restImage,
            //                                     fit: BoxFit.cover,
            //                                   )))
            //                               : Row(
            //                                   children: [
            //                                     SizedBox(
            //                                       width: 15,
            //                                     ),
            //                                     CustomContainer(
            //                                         height: 17,
            //                                         width: 17,
            //                                         child: Image.asset(
            //                                             'assets/images/homeicon.png')),
            //                                   ],
            //                                 ),
            //                           SizedBox(width: 13),
            //                           SizedBox(
            //                             width: MediaQuery.of(context)
            //                                     .size
            //                                     .width /
            //                                 1.7,
            //                             child: Column(
            //                               crossAxisAlignment:
            //                                   CrossAxisAlignment.start,
            //                               children: [
            //                                 CustomText(
            //                                     text: delType ==
            //                                             'restaurant'
            //                                         ? restaurantName
            //                                         : tripData['pickupDetails']
            //                                                 ?[0]?['name']
            //                                             .toString(),
            //                                     style: CustomTextStyle
            //                                         .smallText),
            //                                 CustomText(
            //                                   text: delType == 'restaurant'
            //                                       ? restaurantAddress
            //                                       : tripData['pickupDetails']
            //                                                   ?[0]
            //                                               ?['fullAddress']
            //                                           .toString(),
            //                                   style: CustomTextStyle
            //                                       .smallGreyText,
            //                                 )
            //                               ],
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ]),
            //                      CustomSizedBox(
            //               height: 12,
            //             ),
            //             paymentmethod==null||paymentmethod.isEmpty?SizedBox():
            //              Text("Payment Method:",style: CustomTextStyle.smallGreyText),
            //             CustomSizedBox(height: 12),
            //            Row(
            //              children: [
            //               SizedBox(width: 15),
            //              paymentmethod==null||paymentmethod.isEmpty?SizedBox(): Container(
            //                       height: 25,
            //                       width: 25,
            //                       child: Image.asset(
            //                           'assets/images/income.png'),
            //                     ),
            //              SizedBox(width: 17),
            //                paymentmethod==null||paymentmethod.isEmpty?SizedBox(): Text(
            //                     paymentmethod.toString(),
            //                     style: CustomTextStyle.smallGreyText),
            //              ],
            //            ),
            //                 CustomSizedBox(
            //                   height: 12,
            //                 ),
            //                 additionalInstructions==null||additionalInstructions.isEmpty?SizedBox():
            //              Text("Delivery Instructions:",style: CustomTextStyle.smallGreyText),
            //             CustomSizedBox(height: 12),
            //            Row(
            //              children: [
            //               SizedBox(width: 15),
            //              additionalInstructions==null||additionalInstructions.isEmpty?SizedBox(): Container(
            //                       height: 17,
            //                       width: 17,
            //                       child: Image.asset(
            //                           'assets/images/info.png',color: Customcolors.darkPurple,),
            //                     ),
            //              SizedBox(width: 17),
            //                additionalInstructions==null||additionalInstructions.isEmpty?SizedBox(): Text(
            //                     additionalInstructions.toString().capitalizeFirst.toString(),
            //                     style: CustomTextStyle.smallGreyText),
            //              ],
            //            ),
            //             CustomSizedBox(height: 12),
            //                 DottedLine(),
            //                 CustomSizedBox(
            //                   height: 15,
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: CustomButton(
            //                     width: double.infinity,
            //                     borderRadius: BorderRadius.circular(20),
            //                     onPressed: () {
            //                       if (widget.roundTrip == true) {
            //                         orderUpdateController
            //                             .updateDeliveredStatus(
            //                           tripData['_id'] ?? '',
            //                           DateTime.now(),
            //                         );
            //                       } else {
            //                         orderUpdateController
            //                             .updateReachedDeliveryStatus(
            //                           tripData['_id'] ?? '',
            //                           DateTime.now(),
            //                         );
            //                       }
            //                     },
            //                     child: CustomText(
            //                       text: widget.roundTrip == true
            //                           ? 'End Trip'
            //                           : delType == 'restaurant'
            //                               ? 'Reached Delivery Location'
            //                               : 'Reached Drop Location',
            //                       style: CustomTextStyle.buttonText,
            //                     ),
            //                   ),
            //                 ),
            //                 SizedBox(height: 10)
            //               ],
            //             ),
            //           ),
            //         )),
            //   ],
            // ),
          ]));
        }));
  }
}
