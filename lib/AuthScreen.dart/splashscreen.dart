// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'dart:async';
import 'package:miogra_service/Const.dart/time_convert_values.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/tripscontroller.dart';
import 'package:miogra_service/Controller.dart/ProfileController/redirectcontroller.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:get/get.dart';
import 'package:miogra_service/AuthScreen.dart/loginscreen.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../Controller.dart/AuthController.dart/tokencontroller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  TokenController tokenController = Get.put(TokenController());
  RedirectController redirect = Get.put(RedirectController());
  final NewTripsController newTripsController = Get.put(NewTripsController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("vvvvvvvvvvvvvvvvvvvvvvvvvvv$parenAdminId");
      await GetStorage.init(); // Ensure storage is initialized
      mobilenumb = getStorage.read("mobilenumb");
      Usertoken = getStorage.read("Usertoken");
      UserId = getStorage.read("UserId");
      useremail = getStorage.read("useremail");
      String dateCurent = TimerdataService().apiselectdateCallDate();

      newTripsController.getNewTrips(
          startdate: dateCurent == "null" ? "" : dateCurent,
          endDate: dateCurent == "null" ? "" : dateCurent);

      // Print values for debugging
      print("Usertokennn: $Usertoken");
      print("Mobilenumb: $mobilenumb");
      print("UserId: $UserId");

      Timer(Duration(seconds: 1), () {
        print("Usertokennn...........: $Usertoken");
        print("Mobilenumb.........: $mobilenumb");
        print("UserId.........: $UserId");
        _initializeSplash();
        if (mobilenumb != null) {
          tokenController.tokenapi(mobileNo: mobilenumb);
        } else {
          Get.off(() => LoginScreen());
        }
      });
    });
  }

  void _initializeSplash() async {
    await redirect.getredirectDetails();

    var data = redirect.redirectLoadingDetails["data"];
    if (data != null && data is List) {
      for (var item in data) {
        if (item["key"] == "imageUrlLink" && item["value"] != null) {
          globalImageUrlLink = item["value"];
          print("Loaded globalImageUrlLink: $globalImageUrlLink");
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomContainer(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Gemini_Generated_Image_xoc37cxoc37cxoc3.png'),
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}
