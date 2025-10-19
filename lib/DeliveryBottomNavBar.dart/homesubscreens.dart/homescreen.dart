// ignore_for_file: depend_on_referenced_packages, unused_field, prefer_final_fields, deprecated_member_use

import 'dart:async';
import 'dart:ui';
import 'package:miogra_service/AuthScreen.dart/loginscreen.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/orderonprocessstatus.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/tripscontroller.dart';
import 'package:miogra_service/Controller.dart/ProfileController/activestatusupdate.dart';
import 'package:miogra_service/Controller.dart/ProfileController/depositcontroller.dart';
import 'package:miogra_service/Controller.dart/ProfileController/profilescreencontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/home_screen_multi_trip.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/newordersbotomsheet.dart';
import 'package:miogra_service/widgets.dart/custom_apputil.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_snackbar.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final bool showBottomSheet;

  final bool? pendingRequest;

  const HomeScreen({
    super.key,
    this.showBottomSheet = false,
    this.pendingRequest,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //bool _switchValue = false;
  Completer<GoogleMapController> _controller = Completer();
  final Location _locationController = Location();
  LatLng? _currentP;
  bool reachedRestaurant = false;
  Widget? _preloadedOrderDetailsWidget;
  Set<google_maps.Marker> markers = {};
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
    _isMounted = true;
    switchValue = storage.read('switchStatus') ?? false;
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
    });
    orderOnProcessController.orderOnProcessStatus(
        startdate: currentDateGlobal, enddate: currentDateGlobal);
    _preloadedOrderDetailsWidget = NewOrdersBottomSheet(
      isActive: switchValue,
      scrollController: _scrollController,
    );

    if (widget.showBottomSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showBottomSheet(context);
      });
    }
  }

  @override
  void dispose() {
    _isMounted = false;

    super.dispose();
  }

  void _showNotification(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => CustomSnackBar(message: message),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  bool _isLoading = false;

  void _toggleSwitch() async {
    if (widget.pendingRequest == true) {
      _showNotification('Your request is under review');
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        await Future.delayed(Duration(seconds: 1));

        setState(() {
          switchValue = !switchValue;
          storage.write('switchStatus', switchValue);

          DateTime now = DateTime.now();
          String formattedStartDateTime = DateFormat('MM-dd-yyyy').format(now);
          String formattedEndDateTime = DateFormat('MM-dd-yyyy').format(now);

          if (!switchValue) {
            _activeStatusUpdatecontroller.updatActiveStatus("offline");
            if (vendorId == null) {
              return;
            }
            _depositUpdatecontroller.updateDeposit(
                formattedStartDateTime, formattedEndDateTime, vendorId ?? '');
            // print('vendor id .............${ vendorId}');
          } else {
            _activeStatusUpdatecontroller.updatActiveStatus("online");
            if (vendorId == null) {
              return;
            }
            _depositUpdatecontroller.updateDeposit(
                formattedStartDateTime, null, vendorId ?? '');
          }
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
    final int markerSize = 80;

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Paint paint = Paint()..color = Color.fromARGB(255, 248, 90, 5);
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

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Stack(
            children: [
              CustomContainer(
                height: MediaQuery.of(context).size.height / 1.7,
                width: MediaQuery.of(context).size.width / 1.2,
                borderRadius: BorderRadius.circular(15),
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 7,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Image.asset('assets/images/popup.png'),
                      ),
                      CustomSizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.7,
                        child: Text(
                          'Your request is on the way! We’re reviewing your application, and you’ll hear from us soon. If selected, expect an email from Miogra Team',
                          textAlign: TextAlign.center,
                          style: CustomTextStyle.helloText,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      CustomSizedBox(height: 10),
                      Text(
                        'If you need any assistance please contact :',
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.popText,
                      ),
                      CustomSizedBox(height: 5),
                      GestureDetector(
                        onTap: () async {
                          final Uri params = Uri(
                            scheme: 'mailto',
                            path:
                                'fastxservices7@gmail.com', //add subject and body here
                          );
                          var url = params.toString();
                          try {
                            await canLaunch(url);
                            await launch(url);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Something went wrong when launching URL"),
                              ),
                            );
                            // ignore: avoid_print
                            print("error");
                          }
                        },
                        child: Text(
                          'fastx@gmail.com',
                          textAlign: TextAlign.center,
                          style: CustomTextStyle.bluepopText,
                        ),
                      ),
                      CustomSizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Logout?",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              16.0), // Add some spacing between the text and buttons
                                      Text(
                                        "Are you sure you want to logout?",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      SizedBox(
                                          height:
                                              24.0), // Add some spacing before the buttons
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Center(child: Text('No')),
                                            ),
                                          ),
                                          CustomButton(
                                              height: 40,
                                              width: 100,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              onPressed: () {
                                                // Perform logout
                                                getStorage.remove("mobilenumb");
                                                getStorage.remove("Usertoken");
                                                getStorage.remove("UserId");
                                                getStorage.remove("username");
                                                UserId = '';
                                                Usertoken = '';
                                                mobilenumb = '';
                                                username = '';
                                                // Navigate to the login screen after logout
                                                Get.offAll(() => LoginScreen());
                                              },
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Text(
                          'Logout?',
                          textAlign: TextAlign.center,
                          style: CustomTextStyle.bluepopText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSizedBox(height: 10),
                        Center(
                          child: CustomContainer(
                            height: 10,
                            width: 50,
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: NewOrdersBottomSheet(
                            isActive: switchValue,
                            scrollController: scrollController,
                            currentP: _currentP,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  DateTime? _lastPressedAt; // Save the last back press time

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        DateTime now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > Duration(seconds: 2)) {
          // If the last press was longer than 2 seconds ago, show a message and reset the timer
          _lastPressedAt = now;
          AppUtils.showToast('Press Back again to exit');

          return; // Don't close the app yet
        }

        SystemNavigator.pop(); // This will close the app
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Hello, Welcome',
                    style: CustomTextStyle.helloText,
                  ),
                  Text(
                    widget.pendingRequest == true
                        ? ''
                        : (username.toString().isNotEmpty
                            ? '${username.toString()[0].toUpperCase()}${username.toString().substring(1)}'
                            : ''),
                    style: CustomTextStyle.mediumBoldText,
                  ),
                ],
              ),
              GestureDetector(
                onTap: _isLoading ? null : _toggleSwitch,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                    color: switchValue ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: switchValue
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: switchValue ? 8 : 27,
                        right: switchValue ? 27 : 8,
                        top: 4,
                        bottom: 4,
                        child: Center(
                          child: _isLoading
                              ? SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 1.5,
                                  ),
                                )
                              : Text(
                                  switchValue ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    child: _currentP == null
                        ? Center(
                            child: LottieBuilder.asset(
                              'assets/animations/Animation - 1720333599352.json',
                              height: 75,
                            ),
                          )
                        : GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: _currentP! ?? LatLng(0.0, 0.0),
                                zoom: 5),
                            markers: Set<google_maps.Marker>.from(markers),
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                              if (_currentP != null) {
                                _cameraToPosition(_currentP!);
                              }
                            },
                          )),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                widget.pendingRequest == true
                    ? CustomContainer(
                        height: MediaQuery.of(context).size.height / 8,
                        width: MediaQuery.of(context).size.width,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomSizedBox(height: 10),
                              Center(
                                child: CustomContainer(
                                  height: 7,
                                  width: 45,
                                  borderRadius: BorderRadius.circular(10),
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                              CustomSizedBox(height: 20),
                              InkWell(
                                onTap: () => _showPopup(context),
                                child: Text(
                                  'Your request is under review',
                                  style: CustomTextStyle.blueAmountText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GestureDetector(
                        onVerticalDragUpdate: (details) {
                          if (_currentP == null) {
                            _showNotification(
                                'Hold on, tracking your location...');
                          } else if (details.primaryDelta! < -10) {
                            _showBottomSheet(context);
                          }
                        },
                        onTap: () {
                          if (_currentP == null) {
                            _showNotification(
                                'Hold on, tracking your location...');
                          } else {
                            _showBottomSheet(context);
                          }
                        },
                        child: CustomContainer(
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.width,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomSizedBox(height: 10),
                                Center(
                                  child: CustomContainer(
                                    height: 7,
                                    width: 45,
                                    borderRadius: BorderRadius.circular(10),
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                                CustomSizedBox(height: 20),
                                Text(
                                  'New Trips',
                                  style: CustomTextStyle.stepTitleText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
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
    } else {}
  }
}
