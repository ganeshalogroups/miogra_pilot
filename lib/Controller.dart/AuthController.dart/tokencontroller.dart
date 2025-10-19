// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'dart:convert';
import 'package:miogra_service/AuthScreen.dart/loginscreen.dart';
import 'package:miogra_service/AuthScreen.dart/request_permission_screen.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Controller.dart/ProfileController/profilescreencontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/bottom_navigation_bar.dart';
import 'package:miogra_service/Model.dart/tokenmodel.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:miogra_service/stepperscreen.dart/step_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class TokenController extends GetxController {
  final ProfilScreeenController profilScreeenController =
      Get.put(ProfilScreeenController());

  String usertoken = getStorage.read("Usertoken") ?? '';
  var istokendataLoading = false.obs;
  TokenModel? tokendetails;

  void tokenapi({String? mobileNo}) async {
    print('token.......');
    Location location = Location();

    try {
      istokendataLoading(true);

      var response = await http.post(
        Uri.parse(API.token),
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $usertoken',
        },
        body: jsonEncode(
            <String, dynamic>{"mobileNo": mobileNo, "role": "deliveryman"}),
      );

      var result = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        print('token 200...........');

        tokendetails = TokenModel.fromJson(result);

        if (tokendetails!.status == true) {
          getStorage.write('username', tokendetails!.data.data.userName);
          getStorage.write("mobilenumb", tokendetails!.data.data.mobileNo);
          getStorage.write("Usertoken", tokendetails!.data.token);
          getStorage.write("UserId", tokendetails!.data.data.userId);
          getStorage.write("useremail", tokendetails!.data.data.email);

          UserId = tokendetails!.data.data.userId;
          Usertoken = tokendetails!.data.token;
          username = tokendetails!.data.data.userName;
          useremail = tokendetails!.data.data.email;
          mobilenumb = tokendetails!.data.data.mobileNo;
          profilScreeenController.getProfile();
          print('--------------token--------');
          print(tokendetails!.data.token);
          print(tokendetails!.data.data.userId);
          PermissionStatus permission = await location.hasPermission();
          var servicestatus = await location.serviceEnabled();

          if (permission == PermissionStatus.granted && servicestatus) {
            await Get.offAll(
              DeliveryBottomNavigation(showBottomSheet: false),
            );
          } else {
            await Get.offAll(RequestPermissionPage(isEnabled: true));
          }
        }
      } else if (response.statusCode == 400 &&
          result['message'] == "User Not Verified from admin end") {
        Get.off(DeliveryBottomNavigation(
          showBottomSheet: false,
          pendingrequest: true,
        ));
        print('tokenuser not verified 400...........');
      } else if (response.statusCode == 400 &&
          result['message'] == "User Has Blocked By Admin") {
        Get.snackbar(
          'Error',
          'You have been blocked!!!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('token user blocked verified 400...........');
      } else if (response.statusCode == 400 &&
          result['message'] == "User Not Found") {
        print('token login');
        print('token error message............${result['message']}');
        Get.off(StepTabBar(
          loginMobileNumb: mobileNo.toString(),
        ));
        print('token  verified 400...........');
      } else {
        Get.off(() => LoginScreen());
      }
    } catch (error) {
      // Handle other errors, if needed
      print('Error occurred in token: $error');
    } finally {
      istokendataLoading(false);
    }
  }
}
