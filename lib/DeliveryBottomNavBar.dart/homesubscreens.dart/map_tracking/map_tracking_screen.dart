// ignore_for_file: avoid_print, unnecessary_null_comparison, unused_local_variable

import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/homescreen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/map_tracking/map_tracking_service.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/map_tracking/map_value_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapTrackingScreen extends StatefulWidget {
  final String orderId;
  final String id;
  final bool isAccepted;
  final double? restLat;
  final double? restLong;
  final double? delLat;
  final double? delLong;
  final bool restarantlocation;
  final String tripStatus;
  MapTrackingScreen(
      {super.key,
      required this.orderId,
      required this.isAccepted,
      required this.id,
      this.restLat,
      this.restLong,
      this.delLat,
      this.delLong,
      required this.restarantlocation,
      required this.tripStatus});

  @override
  State<MapTrackingScreen> createState() => _MapTrackingScreenState();
}

class _MapTrackingScreenState extends State<MapTrackingScreen> {
  Completer<GoogleMapController> controllerr = Completer();
  final MapValueController mapValueController = Get.put(MapValueController());

  HomeScreen homeScreen = HomeScreen();
  static LatLng pRestaurant =
      LatLng(8.1744, 77.4322); // Example restaurant location
  static LatLng customerLocation = LatLng(8.1744, 77.4322);
  Location locationController = Location();
  LatLng? currentLocation;
  //LatLng? currentP = null;
  final Set<Polyline> polylines = {};
  // final String staticPolyline = "encoded_polyline_string_here";
  Location locationService = Location();
  GoogleMapController? mapController;
  BitmapDescriptor? restLocationIcon;
  BitmapDescriptor? delLocationIcon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Update state here
        setCustomMarkers();
        listenToLocationChanges();
        // print('===Order Id==========> ${widget.orderId}');
        if (widget.restLat != null && widget.restLong != null) {
          setState(() {
            pRestaurant = LatLng(widget.restLat!, widget.restLong!);
          });
        }

        if (widget.delLat != null && widget.delLong != null) {
          setState(() {
            customerLocation = LatLng(widget.delLat!, widget.delLong!);
          });
        }
      });
    });
    if (widget.tripStatus != "new") {
      mapValueController.isAccept.value = true;
    } else {
      mapValueController.isAccept.value = widget.isAccepted;
    }
  }

  Future<void> setCustomMarkers() async {
    try {
      restLocationIcon = await resizeMarkerImage(
          'assets/images/Courier.png', 175, 175); // Resize to 48x48 pixels
      delLocationIcon = await resizeMarkerImage(
          'assets/images/Destination.png', 175, 175); // Resize to 48x48 pixels
    } catch (e) {
      // print("Error loading custom markers: $e");
    }
  }

  Future<BitmapDescriptor> resizeMarkerImage(
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

  StreamSubscription<LocationData>? locationSubscription;

  LatLng? lastUpdatedLocation;
  final double minDistanceThreshold = 5.0; // meters
  void listenToLocationChanges() {
    locationSubscription =
        locationService.onLocationChanged.listen((locationData) async {
      if (locationData != null) {
        print(
            'New location received mmm: ${mapValueController.isAccept.value} ${locationData.latitude}, ${locationData.longitude}');
        LatLng newLocation = LatLng(
          locationData.latitude ?? 0.0,
          locationData.longitude ?? 0.0,
        );
        // Calculate distance between last location and new one
        print("New location received: 2");
        // if (lastUpdatedLocation == null ||
        //     calculateDistance(lastUpdatedLocation!, newLocation) >=
        //         minDistanceThreshold) {
        lastUpdatedLocation = newLocation;

        setState(() {
          currentLocation = newLocation;
        });
        print("New location received: 3");

        if (widget.orderId.toString().isEmpty) {
          print("routeee:orderId is empty in map screen");
        } else {
          print("New location received: 4");
          print("update data fire ${newLocation.latitude} ${widget.orderId} ");
          if (mapValueController.isAccept.value == true) {
            print("New location received: 4");
            print(
                "update data fire ${newLocation.latitude} ${widget.orderId} ");
            try {
              await updateFirebaseRealtimeDatabase(
                orderId: widget.orderId,
                latitude: newLocation.latitude,
                longitude: newLocation.longitude,
                timestamp: DateTime.now(),
                accuracy: locationData.accuracy ?? 0.0,
                altitude: locationData.altitude ?? 0.0,
                heading: locationData.heading ?? 0.0,
                speed: locationData.speed ?? 0.0,
                speedAccuracy: locationData.speedAccuracy ?? 0.0,
                headingAccuracy: locationData.headingAccuracy ?? 0.0,
              );
            } catch (e) {
              print("erorror update");
            }
            await updatePolylines();
            // Only move camera once
            if (isFirstLocationUpdate) {
              moveCameraToBounds(
                polylines.expand((polyline) => polyline.points).toList(),
              );
              isFirstLocationUpdate = false;
            }
          } else {
            // Only move camera once
            if (isFirstLocationUpdate) {
              moveCameraToBounds(
                polylines.expand((polyline) => polyline.points).toList(),
              );
              isFirstLocationUpdate = false;
            }
          }

          // moveCameraToBounds(
          //     polylines.expand((polyline) => polyline.points).toList());
          // }
        }
        //  }
      }
    });
  }

  bool isFirstLocationUpdate = true;

  double calculateDistance(LatLng start, LatLng end) {
    const earthRadius = 6371000; // meters
    final dLat = _degreesToRadians(end.latitude - start.latitude);
    final dLng = _degreesToRadians(end.longitude - start.longitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(start.latitude)) *
            cos(_degreesToRadians(end.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    mapController?.dispose();
    super.dispose();
  }

  Future<void> updateFirebaseRealtimeDatabase({
    required String orderId,
    required double longitude,
    required double latitude,
    required DateTime timestamp,
    required double accuracy,
    required double altitude,
    required double heading,
    required double speed,
    required double speedAccuracy,
    required double headingAccuracy,
  }) async {
    try {
      DatabaseReference locationRef =
          FirebaseDatabase.instance.ref('deliveryManPositions/$orderId');

      await locationRef.update({
        'longitude': longitude,
        'latitude': latitude,
        'timestamp': timestamp.toIso8601String(),
        'accuracy': accuracy,
        'altitude': altitude,
        'heading': heading,
        'speed': speed,
        'speedAccuracy': speedAccuracy,
        'headingAccuracy': headingAccuracy,
      });
    } catch (e) {
      // print('$e');
    }
  }

  Future<void> getDirections(LatLng origin, LatLng destination) async {
    final String apiKey ="AIzaSyCJsmwlhksyLs9IGRpkbM90c-RqtIBHqtQ";
    // "AIzaSyCxjzqu6TtZl--tNK_tK6IhAdrTo2AwYc0";
    final String url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&mode=driving&key=$apiKey';

    try {
      var response = await Dio().get(url);

      if (response.statusCode == 200) {
        print("Response direction api ${response.statusCode}");
        Map<String, dynamic> data = response.data;
        List<dynamic> routes = data['routes'];

        if (routes.isNotEmpty) {
          String encodedPolyline = routes[0]['overview_polyline']['points'];
          setPolyline(encodedPolyline);
        }
      }
    } catch (e) {
      // print('$error');
    }
  }

  void setPolyline(String encodedPolyline) {
    List<LatLng> polylinePoints = decodePolyline(encodedPolyline);

    setState(() {
      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: polylinePoints,
          color: Color.fromARGB(255, 248, 90, 5),
          width: 4,
        ),
      );
    });
    if (isFirstLocationUpdate) {
      moveCameraToBounds(
        polylines.expand((polyline) => polyline.points).toList(),
      );
      isFirstLocationUpdate = false;
    }

    // moveCameraToBounds(polylinePoints);
  }

  Future<void> updatePolylines() async {
    if (currentLocation != null) {
      try {
        // final encodedPolyline =await MapTrackingService().getPolylineString(currentLocation!,
        //     widget.restarantlocation == true ? pRestaurant : customerLocation);
        final encodedPolyline = await MapTrackingService()
            .getPolylineWithoutKey(
                currentLocation!,
                widget.restarantlocation == true
                    ? pRestaurant
                    : customerLocation);

        List<LatLng> polylinePoints = decodePolyline(encodedPolyline);

        if (polylinePoints.isEmpty) {
          return;
        }

        setState(() {
          polylines.clear();
          polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: polylinePoints,
              color: Color.fromARGB(255, 248, 90, 5),
              width: 4,
            ),
          );
        });

        // Call updateCameraPosition only if polylinePoints is not empty
        // updateCameraPosition();
      } catch (e) {
        // print('$error');
      }
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;
      poly.add(LatLng(
        (lat / 1E5).toDouble(),
        (lng / 1E5).toDouble(),
      ));
    }

    return poly;
  }

  // void updateCameraPosition() async {
  //   final GoogleMapController controller = await controllerr.future;
  //   controller.animateCamera(CameraUpdate.newLatLngBounds(
  //     calculateBounds(
  //         polylines.expand((polyline) => polyline.points).toList()),
  //     50,
  //   ));
  // }

  LatLngBounds calculateBounds(List<LatLng> points) {
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

  void moveCameraToBounds(List<LatLng> polylinePoints) {
    if (polylinePoints.isNotEmpty) {
      LatLngBounds bounds;
      if (polylinePoints.length == 1) {
        bounds = LatLngBounds(
            southwest: polylinePoints.first, northeast: polylinePoints.first);
      } else {
        bounds = calculateBounds(polylinePoints);
      }
      //  mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(mapValueController.isAccept.value.toString()),
        Expanded(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLocation ??
                  (widget.restarantlocation == true
                      ? pRestaurant
                      : customerLocation),
              zoom: 14.0,
            ),
            markers: {
              if (currentLocation != null)
                Marker(
                  markerId: MarkerId("currentLocation"),
                  icon: restLocationIcon ?? BitmapDescriptor.defaultMarker,
                  position: currentLocation!,
                  anchor: Offset(0.5, 0.5),
                ),
              if (pRestaurant != null && widget.restarantlocation == true)
                Marker(
                  markerId: MarkerId('restaurantLocation'),
                  position: pRestaurant,
                  icon: delLocationIcon ?? BitmapDescriptor.defaultMarker,
                  anchor: Offset(0.5, 0.5),
                ),
              if (customerLocation != null && widget.restarantlocation == false)
                Marker(
                  markerId: MarkerId('customerLocation'),
                  position: customerLocation,
                  icon: delLocationIcon ?? BitmapDescriptor.defaultMarker,
                  anchor: Offset(0.5, 0.5),
                ),
            },
            polylines: polylines,
            zoomControlsEnabled: false, // Disables default zoom controls

            onMapCreated: (GoogleMapController controller) {
              controllerr
                  .complete(controller); // Complete the controller future
              mapController = controller; // Assign controller to the variable
              //  updateCameraPosition(); // Move the camera to the initial position
              if (polylines.isNotEmpty) {
                moveCameraToBounds(
                    polylines.expand((polyline) => polyline.points).toList());
              }
            },
          ),
        ),
      ],
    );
  }
}
