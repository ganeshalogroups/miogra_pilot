// ignore_for_file: depend_on_referenced_packages, unused_field, prefer_final_fields, deprecated_member_use, avoid_print

import 'dart:async';
import 'dart:ui';
import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/Const.dart/time_convert_values.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/orderonprocessstatus.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/tripscontroller.dart';
import 'package:miogra_service/Controller.dart/ProfileController/activestatusupdate.dart';
import 'package:miogra_service/Controller.dart/ProfileController/depositcontroller.dart';
import 'package:miogra_service/Controller.dart/ProfileController/profilescreencontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/tripslistscreens/completed_trip_list_design.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/tripslistscreens/new_trip_screen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/tripslistscreens/ongoing_trip_list_screen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/tripslistscreens/user_active_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeScreenMultiTrip extends StatefulWidget {
  final bool showBottomSheet;

  final bool? pendingRequest;

  const HomeScreenMultiTrip({
    super.key,
    this.showBottomSheet = false,
    this.pendingRequest,
  });

  @override
  State<HomeScreenMultiTrip> createState() => _HomeScreenMultiTripState();
}

//late TabController _tabController;
bool switchValue = false;
LatLng? _currentP;
Set<google_maps.Marker> markers = {};

class _HomeScreenMultiTripState extends State<HomeScreenMultiTrip>
    with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  final Location _locationController = Location();
late TabController _tabController;
  bool reachedRestaurant = false;
  Widget? _preloadedOrderDetailsWidget;

  final ScrollController _scrollController = ScrollController();
  final OrderOnProcessController orderOnProcessController =
      Get.put(OrderOnProcessController());

  final ActiveStatusController _activeStatusUpdatecontroller =
      Get.put(ActiveStatusController());
  final NewTripsController newTripsController = Get.put(NewTripsController());

  final DepositController _depositUpdatecontroller =
      Get.put(DepositController());
  final ProfilScreeenController profilScreeenController =
      Get.put(ProfilScreeenController());

  String? vendorId;
  String? orderid;
  bool _isMounted = false;
  final storage = GetStorage();
  @override
  void initState() {
    super.initState();

   
   



    profilScreeenController.getProfile();
    _tabController = TabController(length: 3, vsync: this);
    _isMounted = true;
   switchValue = switchValue;
    getLocationUpdates();
    _setCustomMarker();
    _enableBackgroundMode();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await newTripsController
          .getNewTrips(); // Assuming this method fetches trips

      setState(() {
        if (profilScreeenController.deliveryManpProfile.isNotEmpty) {
          var tripData = profilScreeenController.deliveryManpProfile.first;
          vendorId = tripData["parentAdminUserId"] ?? '';

          if (vendorId == null) {
            return;
          }
          vendorId = tripData["parentAdminUserId"] ?? '';

          if (orderid == null) {
            return;
          }
          orderid = tripData['orderId'] ?? '';
        }
      });


         Timer(Duration(seconds: 0), () {
        print(TimerdataService().apiselectdateCallDate());
        String dateCurent = TimerdataService().apiselectdateCallDate();
        newTripsController.getNewTrips(
            startdate: dateCurent == "null" ? "" : dateCurent,
            endDate: dateCurent == "null" ? "" : dateCurent);
      });
    });
    //newTripsController.getNewTrips();
    // _preloadedOrderDetailsWidget = NewOrdersBottomSheet(
    //   isActive: _switchValue,
    //   scrollController: _scrollController,
    // );

    // if (widget.showBottomSheet) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     _showBottomSheet(context);
    //   });
    // }
  }

  void goToOngoingTab() {
    _tabController.animateTo(1); // 👈 index 1 = Ongoing tab
  }

  @override
  void dispose() {
    _isMounted = false;

    super.dispose();
  }

  Location location = Location();
  bool serviceEnabled = false;
  PermissionStatus? grantedPermission;

  Future<bool> checkPermission() async {
    if (await checkService()) {
      grantedPermission = await location.hasPermission();
      if (grantedPermission == PermissionStatus.denied ||
          grantedPermission == PermissionStatus.deniedForever) {
        grantedPermission = await location.requestPermission();
      }

      if (grantedPermission == PermissionStatus.deniedForever) {
        await Geolocator.openAppSettings();
        return false;
      }
    }
    return grantedPermission == PermissionStatus.granted;
  }

  Future<bool> checkService() async {
    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
      }
    } on PlatformException catch (error) {
      debugPrint('Error code: ${error.code}, message: ${error.message}');
      serviceEnabled = false;
    }
    return serviceEnabled;
  }

  Future<bool> checkBothServices() async {
    bool permissionGranted = await checkPermission();
    if (permissionGranted) {
      bool serviceAvailable = await checkService();
      return serviceAvailable;
    }
    return false;
  }

  void _setCustomMarker() async {
    if (_currentP == null) return;
    final Uint8List markerIcon = await createCustomMarker();
    final google_maps.Marker customMarker = google_maps.Marker(
      markerId: MarkerId("_currentLocation"),
      icon: BitmapDescriptor.fromBytes(markerIcon),
      position: _currentP!,
    );

    if (_isMounted) {
      setState(() {
        markers.add(customMarker);
      });
    }
  }

  Future<Uint8List> createCustomMarker() async {
    int markerSize = 80;

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Paint paint = Paint()..color = Color(0xFF583081);
    canvas.drawCircle(
        Offset(markerSize / 4, markerSize / 4), markerSize / 4, paint);

    final img =
        await pictureRecorder.endRecording().toImage(markerSize, markerSize);
    final ByteData? byteData =
        await img.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _enableBackgroundMode() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    await location.enableBackgroundMode(enable: true);
  }

//ScrollController _scrollController = ScrollController();
  DateTime? _lastPressedAt; // Save the last back press time
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Customcolors.decorationbackground,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              /// **First SliverAppBar - Google Map**
              SliverAppBar(
                  automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                pinned: false,
                centerTitle: false,
                stretch: true,
                expandedHeight: 300.0,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  // background: InkWell(
                  //   onTap: (){
                  //     newTripsController.getNewTrips();
                  //   },
                  //   child: Container(height: 100,
                  //   color: Colors.red,),
                  // ),
                  background: _currentP == null
                      ? Center(child: CircularProgressIndicator())
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _currentP ?? LatLng(0.0, 0.0),
                            zoom: 15,
                          ),
                          markers: markers,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                ),
              ),

              /// **Second SliverAppBar - Tab Bar**
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Customcolors.decorationbackground,
                elevation: 0,
                pinned: true,
                stretch: true,
                floating: false,
                bottom: PreferredSize(
                  preferredSize:
                      Size.fromHeight(50.0), // Set the desired height
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserActiveStatusDesign(
                        pendingRequest: widget.pendingRequest!,
                      ),
                      TabBar(
                        controller: _tabController,
                        indicatorColor: Customcolors.darkPurple,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(text: 'New Orders'),
                          Tab(text: 'Ongoing'),
                          Tab(text: 'Completed'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              NewTripScreen(onAccept: goToOngoingTab,),
              // Column(
              //   children: [
              //     Expanded(
              //       child: NotificationListener<ScrollNotification>(
              //         onNotification: (scrollNotification) {
              //           _scrollController
              //               .jumpTo(scrollNotification.metrics.pixels);
              //           return true;
              //         },
              //         child: SizedBox(
              //           height: MediaQuery.of(context).size.height / 2.2,
              //           child: NewTripScreen(),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              OnGoingTripListScreen(
               // isActive: switchValue,
              ),
              // Column(
              //   children: [
              //     Expanded(
              //       child: NotificationListener<ScrollNotification>(
              //         onNotification: (scrollNotification) {
              //           _scrollController
              //               .jumpTo(scrollNotification.metrics.pixels);
              //           return true;
              //         },
              //         child: SizedBox(
              //           height: MediaQuery.of(context).size.height / 2.2,
              //           child:
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              CompletedTripListScreen()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 15),
      ),
    );
  }

  void getLocationUpdates() async {
    bool isAvailable = await checkBothServices();

    if (isAvailable) {
      final subscription = _locationController.onLocationChanged.listen(
        (LocationData currentLocation) {
          if (mounted) {
            if (currentLocation.latitude != null &&
                currentLocation.longitude != null) {
              setState(() {
                _currentP = LatLng(
                    currentLocation.latitude!, currentLocation.longitude!);
                _setCustomMarker();
              });
              _cameraToPosition(_currentP!);
            } else {}
          }
        },
        onError: (error) {},
      );
      print(subscription);
    } else {}
  }
}
