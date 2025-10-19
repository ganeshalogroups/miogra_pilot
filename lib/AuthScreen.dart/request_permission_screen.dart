import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import '../DeliveryBottomNavBar.dart/bottom_navigation_bar.dart';
import '../widgets.dart/custom_textstyle.dart';

// ignore: must_be_immutable
class RequestPermissionPage extends StatefulWidget {
  bool isEnabled;

  RequestPermissionPage({super.key, required this.isEnabled});

  @override
  _RequestPermissionPageState createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<RequestPermissionPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset('assets/images/locationrequest.png'),
            SizedBox(height: 60),
            Text(
              'Location permission is required to enhance your app experience.',
              style: CustomTextStyle.splashpermissionTitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            CustomButton(
              width: MediaQuery.of(context).size.width / 1,
              borderRadius: BorderRadius.circular(30),
              onPressed: () {
                getLocationAndNavigate(context);
              },
              child: Text(
                'Allow',
                style: CustomTextStyle.buttonText,
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
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

// new method

  void getLocationAndNavigate(context) async {
    try {
      Future.delayed(
        Duration.zero,
        () async {
          await checkBothServices().then((permissions) async {
            if (permissions) {
              Get.off(DeliveryBottomNavigation(showBottomSheet: false));
            }
          });
        },
      );
    } catch (e) {
      debugPrint('Error: xx $e');
    }
  }
}
